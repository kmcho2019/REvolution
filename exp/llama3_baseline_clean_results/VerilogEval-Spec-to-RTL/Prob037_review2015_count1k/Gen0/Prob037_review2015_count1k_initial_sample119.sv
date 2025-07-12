```thought
To implement the TopModule as described, we will use a 10-bit register to store the current count. Since we need to count up to 999, a 10-bit register can hold values up to 1023, which is more than sufficient. The counter will increment on every positive edge of the clock unless the reset signal is high. When the reset signal is high, the counter will reset to 0. We will use a synchronous reset because the problem specifies that the reset is active high synchronous, meaning it only takes effect on the rising edge of the clock. We'll also ensure that the counter stops counting once it reaches 999 and stays at 999 until it is reset, thus maintaining a period of 1000 cycles (counting from 0 to 999 inclusive).
```

```verilog
module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0; // Reset q to 0 when reset is high
    end else if (q == 10'd999) begin
        q <= 10'd999; // Keep q at 999 once it reaches 999
    end else begin
        q <= q + 1; // Increment q otherwise
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
