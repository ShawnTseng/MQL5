<chart>
id=133173500604495562
symbol=EURUSD
description=Euro vs US Dollar
period_type=0
period_size=30
digits=5
tick_size=0.000000
position_time=1672824600
scale_fix=0
scale_fixed_min=1.053500
scale_fixed_max=1.063700
scale_fix11=0
scale_bar=0
scale_bar_val=1.000000
scale=16
mode=1
fore=0
grid=1
volume=1
scroll=0
shift=1
shift_size=20.261438
fixed_pos=0.000000
ticker=1
ohlc=0
one_click=0
one_click_btn=1
bidline=1
askline=0
lastline=0
days=0
descriptions=0
tradelines=1
tradehistory=1
window_left=0
window_top=0
window_right=1415
window_bottom=462
window_type=3
floating=0
floating_left=0
floating_top=0
floating_right=0
floating_bottom=0
floating_type=1
floating_toolbar=1
floating_tbstate=
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=65280
volumes_color=3329330
grid_color=10061943
bidline_color=10061943
askline_color=255
lastline_color=49152
stops_color=255
windows_total=1

<expert>
name=Learn
path=Experts\Shawn\Learn.ex5
expertmode=1
<inputs>
hmaInputPeriod=30.0
hmaInputPrice=5
</inputs>
</expert>

<window>
height=100.000000
objects=6

<indicator>
name=Main
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1
</indicator>

<indicator>
name=Custom Indicator
path=Indicators\HMA.ex5
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=HMA Value
draw=10
style=0
width=2
arrow=251
color=11119017,9639167,3329330
</graph>
<inputs>
inpPeriod=30.0
inpPrice=5
</inputs>
</indicator>
<object>
type=31
name=autotrade #6059018 buy 0.01 EURUSD at 1.05614, EURUSD
hidden=1
color=11296515
selectable=0
date1=1672781341
value1=1.056140
</object>

<object>
type=32
name=autotrade #6060215 sell 0.01 EURUSD at 1.05414, SL, profit -2.0
hidden=1
descr=[sl 1.05414]
color=1918177
selectable=0
date1=1672795521
value1=1.054140
</object>

<object>
type=31
name=autotrade #6065986 buy 0.01 EURUSD at 1.06212, EURUSD
hidden=1
color=11296515
selectable=0
date1=1672837200
value1=1.062120
</object>

<object>
type=32
name=autotrade #6066688 sell 0.01 EURUSD at 1.06009, SL, profit -2.0
hidden=1
descr=[sl 1.06012]
color=1918177
selectable=0
date1=1672841101
value1=1.060090
</object>

<object>
type=2
name=autotrade #6059018 -> #6060215, SL, profit -2.00, EURUSD
hidden=1
descr=1.05614 -> 1.05414
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1672781341
date2=1672795521
value1=1.056140
value2=1.054140
</object>

<object>
type=2
name=autotrade #6065986 -> #6066688, SL, profit -2.03, EURUSD
hidden=1
descr=1.06212 -> 1.06009
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1672837200
date2=1672841101
value1=1.062120
value2=1.060090
</object>

</window>
</chart>