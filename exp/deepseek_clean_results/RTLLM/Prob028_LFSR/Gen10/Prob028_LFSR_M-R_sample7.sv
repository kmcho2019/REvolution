module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active high reset
    output reg [3:0] out   // 4-bit LFSR output
);

// Feedback calculation: XOR of bits 3 and 2 (as per problem description)
wire feedback = ~(out[3] ^ out[2]);  // XOR then invert as specified

// LFSR shift register
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;    // Initialize to 0 on reset
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule