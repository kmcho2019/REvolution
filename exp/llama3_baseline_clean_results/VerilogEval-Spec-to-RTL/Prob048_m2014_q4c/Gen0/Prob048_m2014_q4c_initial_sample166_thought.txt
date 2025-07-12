```thought
To implement a simple D flip flop with active high synchronous reset, we will use a basic sequential logic design. The flip flop will have a clock input (clk), a data input (d), a reset input (r), and a output (q). When the reset (r) is high and the clock (clk) is rising, the output (q) will be reset to 0. Otherwise, on the rising edge of the clock (clk), the output (q) will be updated with the value of the data input (d).
```
```verilog
module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
