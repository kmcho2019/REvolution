```thought
To implement the TopModule, we will use a 10-bit down-counter that can be loaded with the input data at any time. We will also have a flag (tc) that indicates when the counter reaches zero. On the positive edge of the clock, we will check the load signal. If load is high, we will load the counter with the input data. If load is low, we will decrement the counter by 1. Once the counter reaches 0, it will stay 0 until it is loaded again with a new value.
```

```verilog
module TopModule(
    input  clk,
    input  load,
    input  [9:0] data,
    output tc
);

reg [9:0] counter;
assign tc = (counter == 0) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
    end else if (counter > 0) begin
        counter <= counter - 1;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
