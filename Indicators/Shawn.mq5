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
   for(int i = 0; i < count && !IsStopped(); i++) {
      bufferHMA[i] = open[i];
   }
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
