```thought
To implement a D flip-flop with active high synchronous reset, we will use a always block that is sensitive to the positive edge of the clock signal. Inside the always block, we will first check if the reset signal is high. If it is, we will set the output q to 0. If the reset signal is not high, we will set the output q to the value of the input d. This way, when the reset signal is high, the output q will be reset to 0 on the next clock edge, regardless of the input d.
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
