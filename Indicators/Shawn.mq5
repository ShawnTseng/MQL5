//+------------------------------------------------------------------+
//|                                                        Shawn.mq5 |
//|                                                       ShawnTseng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ShawnTseng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

#property indicator_buffers 1 // How many data buffers we are using
#property indicator_plots   1 // How many indicators are being drawn on screen

#property indicator_type1   DRAW_LINE
#property indicator_label1  "Shawn"
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

input double             inpPeriod = 20;          // Period
input ENUM_APPLIED_PRICE inpPrice  = PRICE_CLOSE; // Price

double bufferHMA[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
   SetIndexBuffer(0, bufferHMA, INDICATOR_DATA);
   return(INIT_SUCCEEDED);
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
   // Must respect the stop flag
   if(IsStopped()) {
      return (0);
   }
   // Check that we have enough bars available to calculate
   if(rates_total <= 0) {
      return (0);
   }
   //// 如果指標尚未載入完成，就從頭開始
   if(Bars(_Symbol, _Period) < rates_total) {
      return(prev_calculated);
   }
   //if(BarsCalculated(handle) < rates_total) {
   //   return (0);
   //}
   int count = 0;
   // 超出暫存上限或是第一次執行，全部的bar重新計算
   if(prev_calculated < rates_total || prev_calculated <= 0) {
      count = rates_total;
   } else {
      //新bar的數量，以及當下活的bar
      count = rates_total - prev_calculated;
      if(prev_calculated > 0) {
         count++;
      }
   }
   // 儲存值到buffer中
   for(int i = rates_total - 1; i >= 0 && !IsStopped(); i--) {
      double hma1 = iHull(getPrice(open, close, high, low, i), inpPeriod, i, rates_total, 0);
      double hma2 = iHull(hma1, inpPeriod, i, rates_total, 1);
      bufferHMA[i] = 2.0 * hma1 - hma2;
      //bufferHMA[i] = close[i];
      //bufferHMA[i] = getPrice(open, close, high, low, i);
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
//
//---
//
double getPrice(const double &open[], const double &close[], const double &high[], const double &low[], int i) {
   double result = 0;
   switch(inpPrice) {
   case PRICE_CLOSE:
      result = close[i];
      break;
   case PRICE_OPEN:
      result = open[i];
      break;
   case PRICE_HIGH:
      result = high[i];
      break;
   case PRICE_LOW:
      result = low[i];
      break;
   case PRICE_MEDIAN:
      result = ((high[i] + low[i]) / 2.0);
      break;
   case PRICE_TYPICAL:
      result = ((high[i] + low[i] + close[i]) / 3.0);
      break;
   case PRICE_WEIGHTED:
      result = ((high[i] + low[i] + close[i] + close[i]) / 4.0);
      break;
   default:
      result = close[i]; // for back testing
      Print("for back testing; price", result);
      break;
   }
   return result;
}
//+------------------------------------------------------------------+
