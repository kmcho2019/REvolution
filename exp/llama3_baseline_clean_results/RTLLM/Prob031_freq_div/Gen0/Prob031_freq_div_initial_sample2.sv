```thought
To implement the frequency divider module `freq_div`, we will use three counters to divide the input clock frequency. For the 50MHz clock, we will use a simple toggle on every positive edge of the input clock. For the 10MHz clock, we will use a counter `cnt_10` that increments on every positive edge of the input clock and toggles the output when it reaches 4. For the 1MHz clock, we will use a counter `cnt_100` that increments on every positive edge of the input clock and toggles the output when it reaches 49. All counters and outputs will be reset when the `RST` signal is active.
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
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        CLK_50 <= ~CLK_50;
        
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end
        
        cnt_100 <= cnt_100 + 1;
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
