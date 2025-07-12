module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0 to ensure predictable initial condition
);

// Combinational logic for XOR operation
always @(*) begin
    out <= in ^ out; // Directly update the out in the combinational logic block
end

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    // The out has already been updated in the combinational logic block, so no need to re-assign
end

endmodule