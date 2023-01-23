//+------------------------------------------------------------------+
//|                                                        Learn.mq5 |
//|                                       Copyright 2022, ShawnTseng |
//|                                    https://github.com/ShawnTseng |
//+------------------------------------------------------------------+
#property copyright "ShawnTseng"
#property link "https://github.com/ShawnTseng"
#property version "1.00"

input double hmaInputPeriod = 20;
input ENUM_APPLIED_PRICE hmaInputPrice = PRICE_CLOSE;

#include <Trade/Trade.mqh>

CTrade trade;

//+------------------------------------------------------------------+
//|OnInit                                                            |
//+------------------------------------------------------------------+
int OnInit() {
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//|OnDeinit                                                            |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
}
//+------------------------------------------------------------------+
//OnTick                                                             |
//+------------------------------------------------------------------+
void OnTick() {
   // 新的bar，才繼續
   if(!isNewBar()) {
      return;
   }
   // 沒倉位，才繼續
   if(hasPosition()) {
      return;
   } else {
      checkTrailingStop();
   }
   static int ema72Handle = iMA(_Symbol, PERIOD_CURRENT, 72, 0, MODE_EMA, PRICE_CLOSE);
   static int ema220Handle = iMA(_Symbol, PERIOD_CURRENT, 220, 0, MODE_EMA, PRICE_CLOSE);
   static int hmaHandle = iCustom(_Symbol, PERIOD_CURRENT, "HMA.ex5", hmaInputPrice, hmaInputPeriod);
   double ema72Array[];
   double ema220Array[];
   double hmaColorArray[];
   CopyBuffer(ema72Handle, 0, 0, 3, ema72Array);
   CopyBuffer(ema220Handle, 0, 0, 3, ema220Array);
   CopyBuffer(hmaHandle, 1, 0, 3, hmaColorArray);
   ArraySetAsSeries(ema72Array, true);
   ArraySetAsSeries(ema220Array, true);
   ArraySetAsSeries(hmaColorArray, true);
   const int firstBarIndex = 0;
   const int secondBarIndex = 1;
   const int isLongColor = 2;
   const int isBearColor = 1;
   const bool isBull = ema72Array[firstBarIndex] > ema220Array[firstBarIndex];
   const bool isBear = ema72Array[firstBarIndex] < ema220Array[firstBarIndex];
   const bool isLong = (hmaColorArray[firstBarIndex] == isLongColor && hmaColorArray[secondBarIndex] == isBearColor); // 反轉做多訊號
   const bool isShort = (hmaColorArray[firstBarIndex] == isBearColor && hmaColorArray[secondBarIndex] == isLongColor); // 反轉做空訊號
   const bool isHigherThanEMA72 = SYMBOL_ASK > ema72Array[firstBarIndex];
   const bool isLowerThanEMA72 = SYMBOL_BID < ema72Array[firstBarIndex];
   string commentText = "";
   if(isBull) {
      commentText += "1.Bull";
   }
   if(isBear) {
      commentText += "1.Bear";
   }
   if(isLong) {
      commentText += "\n2.Long";
   }
   if(isShort) {
      commentText += "\n2.Short";
   }
   Comment(commentText);
   if(isBull && isHigherThanEMA72 && isLong) {
      Print("HMA color changes from pink to green");
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double stoploss = ask - 350 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      double takeProfit = ask + 700 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Buy(0.01, _Symbol, ask, stoploss, takeProfit, "Long");
   }
   if(isBear && isLowerThanEMA72 && isShort) {
      Print("HMA color changes from green to pink");
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double stoploss = bid + 350 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      double takeProfit = bid - 700 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Sell(0.01, _Symbol, bid, stoploss, takeProfit, "Short");
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar() {
   static datetime timestamp;
   datetime time = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(timestamp == time) {
      return false;
   }
   timestamp = time;
   return true;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool hasPosition() {
   const int total = PositionsTotal();
   if(total > 0) {
      return true;
   }
   return false;
}

void checkTrailingStop(){
   // TODO:
}
//+------------------------------------------------------------------+
