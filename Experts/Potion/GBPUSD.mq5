//+------------------------------------------------------------------+
//|                                                        Learn.mq5 |
//|                                       Copyright 2022, ShawnTseng |
//|                                    https://github.com/ShawnTseng |
//+------------------------------------------------------------------+
#property copyright "ShawnTseng"
#property link "https://github.com/ShawnTseng"
#property version "1.00"

input double hmaInputPeriod = 30;
input ENUM_APPLIED_PRICE hmaInputPrice = PRICE_CLOSE;

double myVolume = 0.1;
int trailingStopLoss = 600;
int stopLoss = 550;
int takeProfit = 1200;

#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>

CTrade trade;
CPositionInfo positionInfo;

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
      checkTrailingStop();
      return;
   }
   static int ema72Handle = iMA(_Symbol, PERIOD_CURRENT, 72, 0, MODE_EMA, PRICE_CLOSE);
   static int ema220Handle = iMA(_Symbol, PERIOD_CURRENT, 220, 0, MODE_EMA, PRICE_CLOSE);
   static int hmaHandle = iCustom(_Symbol, PERIOD_CURRENT, "HMA.ex5", hmaInputPrice, hmaInputPeriod);
   double ema72Array[];
   double ema220Array[];
   double hmaColorArray[];
   CopyBuffer(ema72Handle, 0, 0, 1, ema72Array);
   CopyBuffer(ema220Handle, 0, 0, 1, ema220Array);
   CopyBuffer(hmaHandle, 1, 0, 2, hmaColorArray);
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
   const bool isHigherThanEMA72 = SymbolInfoDouble(_Symbol, SYMBOL_ASK) > ema72Array[firstBarIndex];
   const bool isLowerThanEMA72 = SymbolInfoDouble(_Symbol, SYMBOL_BID) < ema72Array[firstBarIndex];
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
   if(!isLong && !isShort) {
      commentText += "\n2. -";
   }
   if(isHigherThanEMA72) {
      commentText += "\n3.higher Than EMA72";
   }
   if(isLowerThanEMA72) {
      commentText += "\n3.lower Than EMA72";
   }
   Comment(commentText);
   if(isBull && isHigherThanEMA72 && isLong) {
      Print("HMA color changes from pink to green");
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double sl = ask - stopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      double tp = ask + takeProfit * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Buy(myVolume, _Symbol, ask, sl, tp, "Long");
   }
   if(isBear && isLowerThanEMA72 && isShort) {
      Print("HMA color changes from green to pink");
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double sl = bid + stopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      double tp = bid - takeProfit * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      trade.Sell(myVolume, _Symbol, bid, sl, tp, "Short");
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
   return positionInfo.Select(_Symbol);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void checkTrailingStop() {
   if(!hasPosition()) {
      return;
   }
   const ENUM_POSITION_TYPE currentPositionType = positionInfo.PositionType();
   const double currentStopLossPrice = positionInfo.StopLoss();
   const double currentTakeProfitPrice = positionInfo.TakeProfit();
   const double currentPrice = positionInfo.PriceCurrent();
   if(currentPositionType == POSITION_TYPE_BUY) {
      const double newStopLossPrice = currentPrice - trailingStopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      const bool higherThanCurrentStopLossPrice = newStopLossPrice > currentStopLossPrice;
      // 止損位必須比原本止損位還要高
      if(higherThanCurrentStopLossPrice) {
         trade.PositionModify(_Symbol, newStopLossPrice, currentTakeProfitPrice);
      }
   }
   if(currentPositionType == POSITION_TYPE_SELL) {
      const double newStopLossPrice = currentPrice + trailingStopLoss * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      const bool lowerThanCurrentStopLossPrice = newStopLossPrice < currentStopLossPrice;
      // 止損位必須比原本止損位還要低
      if(lowerThanCurrentStopLossPrice) {
         trade.PositionModify(_Symbol, newStopLossPrice, currentTakeProfitPrice);
      }
   }
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
