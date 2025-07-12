```thought
To implement the frequency divider, we need to create a module named 'freq_div' with input ports 'CLK_in' and 'RST', and output ports 'CLK_50', 'CLK_10', and 'CLK_1'. 
The module will use three counters to divide the input clock frequency: one for each output clock frequency. 
The 'CLK_50' will be toggled on every positive edge of 'CLK_in'. 
The 'CLK_10' will be toggled when the counter 'cnt_10' reaches a value of 4, and 'cnt_10' will be reset to 0. 
The 'CLK_1' will be toggled when the counter 'cnt_100' reaches a value of 49, and 'cnt_100' will be reset to 0.
All counters and output clocks will be reset when 'RST' is active.
```

```verilog
module freq_div(
    input           CLK_in,
    input           RST,
    output          CLK_50,
    output          CLK_10,
    output          CLK_1
);

reg               CLK_50_reg;
reg               CLK_10_reg;
reg               CLK_1_reg;
reg [1:0]         cnt_10;
reg [5:0]         cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50_reg <= 1'b0;
        CLK_10_reg <= 1'b0;
        cnt_10 <= 2'b00;
        CLK_1_reg <= 1'b0;
        cnt_100 <= 6'b000000;
    end else begin
        // Generate CLK_50
        CLK_50_reg <= ~CLK_50_reg;

        // Generate CLK_10
        if(cnt_10 == 4'b0100) begin
            CLK_10_reg <= ~CLK_10_reg;
            cnt_10 <= 2'b00;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end

        // Generate CLK_1
        if(cnt_100 == 6'b110001) begin
            CLK_1_reg <= ~CLK_1_reg;
            cnt_100 <= 6'b000000;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

assign CLK_50 = CLK_50_reg;
assign CLK_10 = CLK_10_reg;
assign CLK_1 = CLK_1_reg;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
