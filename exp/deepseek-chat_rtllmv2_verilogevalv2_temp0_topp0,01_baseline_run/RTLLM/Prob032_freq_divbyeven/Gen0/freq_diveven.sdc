current_design freq_diveven
set clk_name clk
set clk_period 0.01
create_clock -name $clk_name -period $clk_period [get_ports clk]
create_clock -name $clk_name -period $clk_period [get_ports clk]
