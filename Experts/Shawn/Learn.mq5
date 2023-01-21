//+------------------------------------------------------------------+
//|                                                        Learn.mq5 |
//|                                       Copyright 2022, ShawnTseng |
//|                                    https://github.com/ShawnTseng |
//+------------------------------------------------------------------+
#property copyright "ShawnTseng"
#property link "https://github.com/ShawnTseng"
#property version "1.00"

input double hmaInputPeriod = 30.0;
input ENUM_APPLIED_PRICE hmaInputPrice = PRICE_MEDIAN;

int hmaHandle;


//+------------------------------------------------------------------+
//|OnInit                                                            |
//+------------------------------------------------------------------+
int OnInit() {
   hmaHandle = iCustom(_Symbol, PERIOD_CURRENT, "Shawn.ex5", hmaInputPrice, hmaInputPeriod);
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//|OnDeinit                                                            |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   IndicatorRelease(hmaHandle);
}
//+------------------------------------------------------------------+
//OnTick                                                             |
//+------------------------------------------------------------------+
void OnTick() {
   //static datetime timestamp;
   //datetime time = iTime(_Symbol, PERIOD_CURRENT, 0);
   //if(timestamp == time) {
   //   return;
   //}
   //timestamp = time;
   // 新長出一根蠟燭時，計算一次
   double hmaBuffer[];
   CopyBuffer(hmaHandle, 0, 0, 1, hmaBuffer);
   Comment("HMA Value [0]:", hmaBuffer[0]);
   //"HMA Value [1]:", hmaBuffer[1],
   //"HMA Value [2]:", hmaBuffer[2]);
   // double hmaPrice = hmaBuffer[1];
   //double closePrice = iClose(_Symbol, PERIOD_CURRENT, 1);
   // Print("First Bar HMA Value is:", hmaBuffer[0]);
   // Print("Second Bar HMA Value is:", hmaBuffer[1]);
   // Print("Check Buy or Sell");
   // 並且在圖表上顯示
   // 再用策略條件開關單
}
//+------------------------------------------------------------------+
