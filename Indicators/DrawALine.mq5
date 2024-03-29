//+------------------------------------------------------------------+
//|                                                    DrawALine.mq5 |
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
#property indicator_label1  "Line"
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

double line[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
   SetIndexBuffer(0, line, INDICATOR_DATA);
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
   drawALine(rates_total, open);
   return(rates_total);
}
//+------------------------------------------------------------------+
void drawALine(const int rates_total, const double &open[]) {
   for(int i = rates_total - 1; i >= 0 && !IsStopped(); i--) {
      line[i] = open[rates_total - 1];
   }
   Comment("Current Open Price: ", open[rates_total - 1]);
}

//+------------------------------------------------------------------+
