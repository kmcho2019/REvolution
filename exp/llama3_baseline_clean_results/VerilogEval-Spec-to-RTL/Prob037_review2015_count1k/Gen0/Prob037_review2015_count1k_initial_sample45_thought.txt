```thought
To solve this problem, we need to create a counter that increments every clock cycle and resets when the reset signal is high. We'll use a 10-bit register to store the current count, which will allow us to count from 0 to 999. We'll use a conditional statement to check if the current count is equal to 999, and if so, reset the count to 0 on the next clock cycle. The reset signal will be used to reset the count to 0 synchronously.
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
        count <= 10'b0;
    end else if (count == 10'd999) begin
        count <= 10'b0;
    end else begin
        count <= count + 1'b1;
    end
end

assign q = count;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
