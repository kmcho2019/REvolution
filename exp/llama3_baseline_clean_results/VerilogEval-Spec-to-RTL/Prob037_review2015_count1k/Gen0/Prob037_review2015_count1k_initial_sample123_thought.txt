```thought
To implement the counter, we will use a 10-bit register to store the count value. We will use a conditional statement to check if the count has reached 999, and if so, reset it to 0 on the next clock cycle. The reset input will be used to asynchronously reset the count to 0. Since the reset is active high synchronous, we will use an if statement to check for reset and reset the count to 0 if it is high. We will use a non-blocking assignment to update the count register to ensure that the new value is only updated on the positive edge of the clock.
```
```verilog
module TopModule (
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
Note: The `[9:0]` notation specifies that `q` and `count` are 10-bit vectors, with bit 9 being the most significant bit and bit 0 being the least significant bit. The `10'd` notation specifies that the number is a decimal number with a width of 10 bits.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
