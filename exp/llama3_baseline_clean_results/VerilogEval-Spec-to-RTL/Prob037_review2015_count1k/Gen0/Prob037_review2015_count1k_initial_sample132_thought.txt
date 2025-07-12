```thought
To solve this problem, we can create a counter that counts from 0 to 999 and then resets to 0. We will use a 10-bit register to store the count, as 2^10 = 1024, which is greater than the required 1000 cycles. The counter will be incremented on every positive edge of the clock and reset to 0 when the reset input is high. We will use a conditional statement to check if the count has reached 999 and reset it to 0 if necessary.
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

Alternatively, we can use a more concise version:

```verilog
module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;

always @(posedge clk) begin
    if (reset || count == 10'd999) begin
        count <= 10'd0;
    end else begin
        count <= count + 1;
    end
end

assign q = count;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
