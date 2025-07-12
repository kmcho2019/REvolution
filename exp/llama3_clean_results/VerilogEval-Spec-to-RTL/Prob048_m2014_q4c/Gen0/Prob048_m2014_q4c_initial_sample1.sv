```thought
To implement a D flip-flop with active high synchronous reset, we will use a simple sequential logic design. The D flip-flop will store the input 'd' on every rising edge of the clock 'clk' unless the reset 'r' is high. If 'r' is high, the output 'q' will be reset to 0 on the next rising edge of 'clk', regardless of the input 'd'.
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
        q <= 0;
    end else begin
        q <= d;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
