```thought
To implement the frequency divider module 'freq_div', we need to create a Verilog design that takes an input clock 'CLK_in' and a reset signal 'RST', and generates three output clocks 'CLK_50', 'CLK_10', and 'CLK_1' with frequencies divided by 2, 10, and 100 respectively. We will use three counters to achieve this: one for each output clock. The counters will be reset on the positive edge of 'RST' or 'CLK_in' when 'RST' is active. Otherwise, the counters will increment or toggle the output clocks based on their current values and thresholds.
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
reg [3:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset all counters and clocks on RST
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        if(cnt_2 == 1'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 1'b0;
        end else begin
            cnt_2 <= cnt_2 + 1'b1;
        end
        
        // Toggle CLK_10 when cnt_10 reaches 4
        if(cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'd0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // Toggle CLK_1 when cnt_100 reaches 49
        if(cnt_100 == 6'd49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'd0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
