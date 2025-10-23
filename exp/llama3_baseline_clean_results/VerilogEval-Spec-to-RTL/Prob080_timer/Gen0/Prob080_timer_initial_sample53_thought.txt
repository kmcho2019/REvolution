```thought
To solve this problem, we'll implement a down-counter using a 10-bit register. The register will be loaded with the input data when the load signal is high. When the load signal is low, the register will decrement by 1 at each positive clock edge. The output signal tc will be asserted when the register reaches 0. We'll use a single D flip-flop to update the register value at each clock cycle.
```
```verilog
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

reg [9:0] counter;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
    end else if (counter > 0) begin
        counter <= counter - 1;
    end
end

always @(*) begin
    tc = (counter == 0) ? 1'b1 : 1'b0;
end

endmodule
```
This code first describes the interface of the TopModule with the given input and output ports. It then declares a 10-bit register `counter` to store the current count. The `always @(posedge clk)` block is used to update the counter value at each positive clock edge. If the load signal is high, the counter is loaded with the input data. If the load signal is low and the counter is greater than 0, the counter is decremented by 1. The `always @(*)` block is used to continuously update the output signal `tc`. If the counter is 0, `tc` is set to 1; otherwise, it is set to 0.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
