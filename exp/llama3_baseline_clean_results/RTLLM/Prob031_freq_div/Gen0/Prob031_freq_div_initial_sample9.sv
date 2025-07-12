```thought
The frequency divider module freq_div will use three counters to generate the desired output clock frequencies. We will use a simple toggle mechanism for the 50MHz clock, and counters to divide the clock frequency for the 10MHz and 1MHz clocks. The counters cnt_10 and cnt_100 will be used to count the number of clock cycles required to divide the input clock frequency. On reset, all the output clocks and counters will be reset to their initial values.
```

```verilog
module freq_div (
    input  CLK_in, 
    input  RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

reg [1:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_10 <= 2'b00;
        cnt_100 <= 6'b000000;
    end else begin
        CLK_50 <= ~CLK_50;

        if (cnt_10 == 4'b1000) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 2'b00;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        if (cnt_100 == 6'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
