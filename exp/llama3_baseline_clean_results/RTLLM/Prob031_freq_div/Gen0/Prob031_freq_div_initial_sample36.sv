```thought
To implement the frequency divider, we will use three counters: one for each output clock frequency. 
For CLK_50, we simply toggle the signal on every rising edge of the input clock.
For CLK_10, we use a counter cnt_10 that increments on every rising edge of the input clock and toggles CLK_10 when it reaches 4.
For CLK_1, we use a counter cnt_100 that increments on every rising edge of the input clock and toggles CLK_1 when it reaches 49.
We also need to reset all counters and output clocks when the reset signal RST is active.
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
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_10 <= 2'b00;
        cnt_100 <= 6'b000000;
    end else begin
        // Toggle CLK_50
        CLK_50 <= ~CLK_50;

        // Generate CLK_10
        if(cnt_10 == 4'b1000) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0000;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end

        // Generate CLK_1
        if(cnt_100 == 6'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
