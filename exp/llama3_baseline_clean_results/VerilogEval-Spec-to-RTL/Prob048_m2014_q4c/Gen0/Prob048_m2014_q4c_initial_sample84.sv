```thought
To implement a simple D flip flop with active high synchronous reset, we will use a process that is sensitive to the clock edge. When the clock rises and the reset is low, the output q will be assigned the value of the input d. If the reset is high at the rising clock edge, the output q will be reset to 0. This is achieved using an if-else statement within the process, where the condition checks the value of the reset signal at the clock edge.
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
