//+------------------------------------------------------------------+
//|                                                  RSIStrategy.mq5 |
//|                                                       ShawnTseng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ShawnTseng"
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>

/**
 * Input
 */
input string _ = "//--- General Settings ---//";
input int Magic_Number = 00000001;
input string Open_Order_Comment = "RSIStrategy";
input int Spread_Filter = 20; // Spread_Filter (0=disable)

input string __ = "//--- Entry Settings ---//";
input int RSI_Period = 14;
input int Overbought = 70;
input int Oversold = 30;
input double First_Order_Log_Size = 0.01;

input string ___ = "//--- Exit Settings ---//";
input int Take_Profit_In_Points = 1000;
input int Stop_Loss_In_Points = 500;

/**
 * Global variables
 */
CTrade ExtTrade;
double Point_Value = 0;
int Number_Of_Buy_Order = 0;
int Number_Of_Sell_Order = 0;
double Open_Price_Of_Buy_Order = 0;
double Open_Price_Of_Sell_Order = 0;
bool Close_Order_Status = true;
int Open_Order_Status = 0;
double rightUpperLabelYPosition = 30;

void CheckOpenedOrders()
{
  Number_Of_Buy_Order = 0;
  Number_Of_Sell_Order = 0;
  Open_Price_Of_Buy_Order = 0;
  Open_Price_Of_Sell_Order = 0;
  
  uint total = OrdersTotal();
  
  for (uint i = 0; i < total; i++)
  {
 
   ulong ticket = OrderGetTicket(i);
   if(ticket)
   {
      long orderMagic = OrderGetInteger(ORDER_MAGIC);
      string symbol = OrderGetString(ORDER_SYMBOL);
      string type = EnumToString(ENUM_ORDER_TYPE(OrderGetInteger(ORDER_TYPE)));
      double openPrice = OrderGetDouble(ORDER_PRICE_OPEN);
      
      if(orderMagic == Magic_Number && symbol == _Symbol){
         if(type == EnumToString(ORDER_TYPE_BUY)){
          Number_Of_Buy_Order++;
          Open_Price_Of_Buy_Order = openPrice;
         }
         if(type == EnumToString(ORDER_TYPE_SELL)){
          Number_Of_Sell_Order++;
          Open_Price_Of_Sell_Order = openPrice;
         }
      }

      printf("#ticket %d %s %s",
            ticket,
            type,
            symbol);
   }
  }
}

void CheckForClose(){
   const double buyTakeProfitPrice = Open_Price_Of_Buy_Order + Take_Profit_In_Points * Point_Value;
   const double buyStopLossPrice = Open_Price_Of_Buy_Order - Stop_Loss_In_Points * Point_Value;
   const double sellTakeProfitPrice = Open_Price_Of_Sell_Order - Take_Profit_In_Points * Point_Value;
   const double sellStopLossPrice = Open_Price_Of_Sell_Order + Stop_Loss_In_Points * Point_Value;
   MqlTick currentPrice;
   SymbolInfoTick(_Symbol, currentPrice);

  if (Number_Of_Buy_Order > 0)
  {
   
    if (Take_Profit_In_Points > 0 && currentPrice.bid >= buyTakeProfitPrice)
    {
      Close_Single_Direction_All_Orders(ORDER_TYPE_BUY);
    }
    if (Stop_Loss_In_Points > 0 && currentPrice.bid <= buyStopLossPrice)
    {
      Close_Single_Direction_All_Orders(ORDER_TYPE_BUY);
    }
  }
  if (Number_Of_Sell_Order > 0)
  {
    if (Take_Profit_In_Points > 0 && currentPrice.ask <= sellTakeProfitPrice)
    {
      Close_Single_Direction_All_Orders(ORDER_TYPE_SELL);
    }
    if (Stop_Loss_In_Points > 0 && currentPrice.ask >= sellStopLossPrice)
    {
      Close_Single_Direction_All_Orders(ORDER_TYPE_SELL);
    }
  }
}

void Check_For_Open()
{
  double RSI_Value = iRSI(Symbol(), 0, RSI_Period, PRICE_CLOSE);

  //if (Spread_Filter >= MarketInfo(Symbol(), MODE_SPREAD) || Spread_Filter == 0)
  //{
  //  if (Number_Of_Buy_Order == 0)
  //  {
  //    if (RSI_Value < Oversold)
  //    {
  //      Open_Order_Status = OrderSend(Symbol(), OP_BUY, Check_Lot_Size(First_Order_Log_Size), Ask, 0, 0, 0, Open_Order_Comment, Magic_Number, 0, Blue);
  //    }
  //  }
  //  if (Number_Of_Sell_Order == 0)
  //  {
  //    if (RSI_Value > Overbought)
  //    {
  //      Open_Order_Status = OrderSend(Symbol(), OP_SELL, Check_Lot_Size(First_Order_Log_Size), Bid, 0, 0, 0, Open_Order_Comment, Magic_Number, 0, Blue);
  //    }
  //  }
  //}
}

void Close_Single_Direction_All_Orders(int Operation_Type)
{
  uint total = OrdersTotal();
  for (uint i = total - 1; i >= 0; i--)
  {
      ulong ticket = OrderGetTicket(i);
      if(ticket)
      {
         long orderMagic = OrderGetInteger(ORDER_MAGIC);
         string symbol = OrderGetString(ORDER_SYMBOL);
         int type = ENUM_ORDER_TYPE(OrderGetInteger(ORDER_TYPE));
         if(orderMagic == Magic_Number && symbol == _Symbol && type == Operation_Type){
            // TODO:Test is if it can close
            // Close_Order_Status = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 0, Green);
            ExtTrade.PositionClose(_Symbol,3);
         }      
      }
  }
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   CheckOpenedOrders();
   CheckForClose();
   Check_For_Open();
  }
