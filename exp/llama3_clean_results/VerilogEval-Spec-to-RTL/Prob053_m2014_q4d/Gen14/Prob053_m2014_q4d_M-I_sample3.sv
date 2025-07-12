module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Initialize internal_out to avoid undefined behavior
reg internal_out = 1'b0;

// Combinational logic for XOR operation
always @(*) begin
    // Compute internal_out based on the current value of out
    internal_out = in ^ out;
end

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    // Update out with the computed XOR result at the rising edge of clk
    out <= internal_out;
end

endmodule