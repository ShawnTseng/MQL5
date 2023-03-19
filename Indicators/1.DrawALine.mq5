//+------------------------------------------------------------------+
//|                                                    DrawALine.mq5 |
//|                                                       ShawnTseng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ShawnTseng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

#property indicator_buffers 0 // How many data buffers we are using
#property indicator_plots   1 // How many indicators are being drawn on screen

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   ObjectDelete(0, "draw a line");
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
   const double currentPrice = open[rates_total - 1];
   ObjectCreate(0, "draw a line", OBJ_HLINE, 0, 0, currentPrice);
   Comment("Current Open Price: ", currentPrice);
}

//+------------------------------------------------------------------+
