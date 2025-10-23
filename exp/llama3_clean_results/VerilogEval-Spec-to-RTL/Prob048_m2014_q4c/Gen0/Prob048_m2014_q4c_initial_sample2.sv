```thought
To implement a simple D flip flop with active high synchronous reset, we will use a basic sequential logic design. The module will have a single D input, a clock input, a reset input, and a Q output. On the rising edge of the clock, if the reset is low, the Q output will be updated with the value of the D input. If the reset is high, the Q output will be set to 0. This ensures that the flip flop is reset to 0 when the reset signal is active high.
```

```verilog
module TopModule(
    input  clk,
    input  d,
    input  r,
    output q
);

reg q_reg;

always @(posedge clk) begin
    if (r) begin
        q_reg <= 0;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
