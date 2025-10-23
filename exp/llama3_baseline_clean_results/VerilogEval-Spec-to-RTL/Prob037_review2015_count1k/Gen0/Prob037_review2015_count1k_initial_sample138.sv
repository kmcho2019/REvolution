```thought
To implement the counter, we will use a 10-bit register to store the current count. We will use a conditional statement to check if the count has reached 999, and if so, reset it to 0 on the next clock cycle. The reset input will be used to asynchronously reset the counter to 0. However, since the reset is specified as synchronous, we will only reset the counter on the positive edge of the clock when the reset is high.
```
```verilog
module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 10'd0;
    end else if (count == 10'd999) begin
        count <= 10'd0;
    end else begin
        count <= count + 1;
    end
end

assign q = count;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
