```thought
To implement the counter module, we can use a 10-bit register to store the current count. The counter will be incremented on every positive clock edge, and reset to 0 when the reset input is high. We will use a conditional statement to check if the count has reached the maximum value (999), and if so, we will reset the count to 0 on the next clock cycle. This will achieve the desired counting period of 1000 cycles.
```

```verilog
module TopModule(
    input  clk,
    input  reset,
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

Note: The above code uses a 10-bit vector to represent the count, with the most significant bit being the 9th bit (as Verilog uses 0-based indexing). The `10'd999` syntax is used to specify a decimal value for the maximum count. The `10'b0` syntax is used to specify a binary value for the reset count.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
