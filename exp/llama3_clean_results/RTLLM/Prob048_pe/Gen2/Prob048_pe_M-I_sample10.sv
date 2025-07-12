// Multiplying Accumulator (MAC) module
module pe (
    input clk, // Clock signal
    input rst, // Reset signal
    input [31:0] a, // 32-bit input operand A
    input [31:0] b, // 32-bit input operand B
    output reg [31:0] c // 32-bit output representing the accumulated result
);

// Reg to hold enable signal for clock gating
reg enable_clk_gating;

// Always block to handle reset and MAC operation
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the accumulator register to 0 on reset
        c <= 32'd0;
        enable_clk_gating <= 1'b0; // Disable clock gating on reset
    end else if (enable_clk_gating) begin
        // Accumulate the product of a and b into the register c
        // Consider using more efficient multiplier architectures here
        c <= c + (a * b);
    end
end

// Clock gating logic
always @ (*) begin
    if (a == 32'd0 || b == 32'd0) begin
        enable_clk_gating <= 1'b0; // Disable clock if either operand is 0
    end else begin
        enable_clk_gating <= 1'b1; // Enable clock otherwise
    end
end

// Note: Further optimizations could include:
// - Exploring different multiplier architectures for better timing and area efficiency
// - Utilizing hardened multiplier-adder blocks if available in the target technology
// - Applying additional power reduction techniques such as voltage scaling if applicable

endmodule