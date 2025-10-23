```thought
To implement the frequency divider, we will use a single always block that is sensitive to the positive edge of the input clock (CLK_in) and the reset signal (RST). Inside this block, we will implement the logic for generating the three output clocks (CLK_50, CLK_10, CLK_1) based on the given conditions. We will use three counters (cnt_2, cnt_10, cnt_100) to keep track of the number of clock cycles for each output clock. 
For CLK_50, we simply toggle its value on every positive edge of CLK_in. 
For CLK_10, we increment the counter cnt_10 and toggle CLK_10 when cnt_10 reaches 4. 
For CLK_1, we increment the counter cnt_100 and toggle CLK_1 when cnt_100 reaches 49. 
On reset, all output clocks and counters are reset to their initial values.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;
reg [2:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50
        if (cnt_2 == 1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 0;
        end else begin
            cnt_2 <= cnt_2 + 1;
        end
        
        // Generate CLK_10
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        // Generate CLK_1
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
