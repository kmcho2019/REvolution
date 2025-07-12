```thought
To implement a simple D flip flop with active high synchronous reset, we will use a reg variable to hold the output value. The output will be updated on the rising edge of the clock if the reset signal is low. If the reset signal is high, the output will be set to 0 regardless of the input or clock. This is a standard implementation of a D flip flop with synchronous reset in Verilog.
```
```verilog
module TopModule(
    input clk,
    input d,
    input r,
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
