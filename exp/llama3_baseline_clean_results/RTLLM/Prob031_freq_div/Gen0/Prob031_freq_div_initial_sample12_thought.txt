```thought
To implement the frequency divider module 'freq_div', we can use three counters to divide the input clock frequency. 
For CLK_50, we simply toggle its value on every positive edge of CLK_in.
For CLK_10 and CLK_1, we use counters cnt_10 and cnt_100 to keep track of the number of clock cycles, 
and toggle their respective output clocks when the counter reaches the desired value.
We also need to consider the reset condition, where the output clocks and counters are reset to 0 when RST is active.
```
```verilog
module freq_div(
    input CLK_in, 
    input RST, 
    output reg CLK_50, 
    output reg CLK_10, 
    output reg CLK_1
);

reg [1:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset all output clocks and counters
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_10 <= 2'b00;
        cnt_100 <= 6'b000000;
    end else begin
        // Generate CLK_50
        CLK_50 <= ~CLK_50;
        
        // Generate CLK_10
        cnt_10 <= cnt_10 + 1'b1;
        if(cnt_10 == 4'b100) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 2'b00;
        end
        
        // Generate CLK_1
        cnt_100 <= cnt_100 + 1'b1;
        if(cnt_100 == 6'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end
    end
end

endmodule
```
This Verilog code implements the 'freq_div' module, which takes an input clock signal 'CLK_in' and a reset signal 'RST', and generates three output clock signals 'CLK_50', 'CLK_10', and 'CLK_1' with frequencies divided by 2, 10, and 100, respectively. The code uses counters to keep track of the clock cycles and toggle the output clocks when the desired frequency is reached. The reset condition is also handled to reset the output clocks and counters to 0 when 'RST' is active.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
