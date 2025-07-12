```thought
To implement the TopModule, we will use a 10-bit register to store the count value. This register will be loaded with the input data when the load signal is high. When the load signal is low, the register will decrement by 1 at each positive clock edge. The tc output will be asserted when the count reaches 0. We will also ensure that once the count reaches 0, it stays 0 until the load signal is asserted again.
```

```verilog
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
assign tc = (count == 0) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (load) begin
        count <= data;
    end else if (count != 0) begin
        count <= count - 1;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
