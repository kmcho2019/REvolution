```thought
The frequency divider module 'freq_div' will be designed using three counters to divide the input clock frequency. 
Each counter will be responsible for generating one of the output clock signals. 
The counters will be implemented using always blocks in Verilog, which are sensitive to the positive edge of the input clock and the reset signal. 
The counters will be reset when the reset signal is active, and they will be incremented or toggled based on their current values and the specified conditions.
```

```code
module freq_div(
    input  CLK_in,
    input  RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;  // not needed but added for better understanding of the process
reg [2:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50 <= 1'b0;
        cnt_2 <= 2'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b0;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b0;
    end else begin
        // For CLK_50
        if(c

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
