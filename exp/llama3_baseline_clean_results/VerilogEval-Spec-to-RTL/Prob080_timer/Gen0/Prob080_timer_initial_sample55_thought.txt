```thought
To implement the TopModule, we will use a single 10-bit down-counter with an enable signal controlled by the load input. When load is high, the counter is loaded with the 10-bit data. When load is low, the counter decrements by 1 on each positive clock edge. The tc (terminal count) signal is asserted when the counter reaches 0 and stays high until the counter is loaded again. We can use a combinational logic to generate the tc signal, which is asserted when the counter value is 0.
```

```verilog
module TopModule(
    input         clk,
    input         load,
    input  [9:0]  data,
    output        tc
);

reg [9:0] counter;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
    end else if (counter > 0) begin
        counter <= counter - 1;
    end
end

assign tc = (counter == 0);

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
