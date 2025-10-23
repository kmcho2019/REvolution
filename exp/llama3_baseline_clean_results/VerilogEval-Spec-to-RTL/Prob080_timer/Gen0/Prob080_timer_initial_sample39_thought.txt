```thought
To solve this problem, we can use a single 10-bit down-counter that is controlled by the load signal. When load is 1, the counter is loaded with the 10-bit data. When load is 0, the counter decrements by 1 on each positive clock edge. The tc output signal is asserted when the counter reaches 0. We will use a 10-bit reg to store the count value, and an always block to handle the counting logic.
```
```verilog
module TopModule(
    input           clk,
    input           load,
    input   [9:0]   data,
    output          tc
);

reg [9:0] count;

always @(posedge clk) begin
    if (load) begin
        count <= data;
    end else if (count > 0) begin
        count <= count - 1;
    end
end

assign tc = (count == 0);

endmodule
```
This Verilog code implements a 10-bit down-counter that meets the specified requirements. The `always` block is triggered on the positive edge of the clock and updates the count value based on the load signal. The `tc` output signal is assigned the value of the comparison `(count == 0)`, which is 1 when the count is 0 and 0 otherwise. Note that the count stays at 0 once it reaches 0, as required, because the `else if` condition is only true when `count > 0`.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
