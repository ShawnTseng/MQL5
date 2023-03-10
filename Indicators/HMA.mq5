//+-----------------------------------------------------------------------------+
//|                                                                         HMA |
//|                        Copyright 2020, Shawn Tseng, refer to © mladen, 2018 |
//|https://www.mql5.com/zh/code/viewcode/20683/189016/zero_lag_hull_average.mq5 |
//+-----------------------------------------------------------------------------+
#property copyright "Shawn Tseng, refer to © mladen, 2018"
#property link      "https://www.mql5.com/zh/code/viewcode/20683/189016/zero_lag_hull_average.mq5"
#property version "2.00"
#property indicator_chart_window

// Indicator properties
#property indicator_buffers 2
#property indicator_plots   1

// Main line properties
#property indicator_color1  clrDarkGray,clrDeepPink,clrLimeGreen
#property indicator_label1  "HMA"
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_width1  2

// inputs
input double             inpPeriod = 20;           // Period
input ENUM_APPLIED_PRICE inpPrice  = PRICE_MEDIAN; // Price

// indicator buffers
double bufferHMA[];
double bufferColor[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
   const string shortName = "HMA (" + (string)inpPeriod + ")";
   SetIndexBuffer(0, bufferHMA, INDICATOR_DATA);
   SetIndexBuffer(1, bufferColor, INDICATOR_COLOR_INDEX);
   IndicatorSetString(INDICATOR_SHORTNAME, shortName);
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator de-initialization function                      |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
   if(Bars(_Symbol, _Period) < rates_total) return(prev_calculated);
   for(int i = (int)MathMax(prev_calculated - 1, 0); i < rates_total && !IsStopped(); i++) {
      double hma1 = iHull(close[i], 20, i, rates_total, 0);
      double hma2 = iHull(hma1, 20, i, rates_total, 1);
      bufferHMA[i] = 2.0 * hma1 - hma2;
      bufferColor[i] = (i > 0) ? (bufferHMA[i] > bufferHMA[i - 1]) ? 2 : (bufferHMA[i] < bufferHMA[i - 1]) ? 1 : bufferColor[i - 1] : 0;
   }
   return(rates_total);
}
//+------------------------------------------------------------------+
//| Custom functions                                                 |
//+------------------------------------------------------------------+
#define _hullInstances 2
#define _hullInstancesSize 2
double workHull[][_hullInstances * _hullInstancesSize];
//
//---
//
double iHull(double price, double period, int r, int bars, int instanceNo = 0) {
   if(ArrayRange(workHull, 0) != bars) ArrayResize(workHull, bars);
   instanceNo *= _hullInstancesSize;
   workHull[r][instanceNo] = price;
   if(period <= 1) return(price);
//
//---
//
   int HmaPeriod  = (int)MathMax(period, 2);
   int HalfPeriod = (int)MathFloor(HmaPeriod / 2);
   int HullPeriod = (int)MathFloor(MathSqrt(HmaPeriod));
   double hma, hmw, weight;
   hmw = HalfPeriod;
   hma = hmw * price;
   for(int k = 1; k < HalfPeriod && (r - k) >= 0; k++) {
      weight = HalfPeriod - k;
      hmw   += weight;
      hma   += weight * workHull[r - k][instanceNo];
   }
   workHull[r][instanceNo + 1] = 2.0 * hma / hmw;
   hmw = HmaPeriod;
   hma = hmw * price;
   for(int k = 1; k < period && (r - k) >= 0; k++) {
      weight = HmaPeriod - k;
      hmw   += weight;
      hma   += weight * workHull[r - k][instanceNo];
   }
   workHull[r][instanceNo + 1] -= hma / hmw;
   hmw = HullPeriod;
   hma = hmw * workHull[r][instanceNo + 1];
   for(int k = 1; k < HullPeriod && (r - k) >= 0; k++) {
      weight = HullPeriod - k;
      hmw   += weight;
      hma   += weight * workHull[r - k][1 + instanceNo];
   }
   return(hma / hmw);
}