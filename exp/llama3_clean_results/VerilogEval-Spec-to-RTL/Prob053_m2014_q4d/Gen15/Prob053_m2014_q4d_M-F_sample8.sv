module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Internal signal for the XOR result, initialized to avoid undefined behavior
reg xor_result = 1'b0;

// Combinational logic for XOR operation
always @(*) begin
    // Compute xor_result based on the current value of in and out
    xor_result = in ^ out;
end

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    // Update out with the computed XOR result at the rising edge of clk
    out <= xor_result;
end

endmodule