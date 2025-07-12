module LFSR (
    input wire clk,        // Clock input (1-bit)
    input wire rst,        // Active high reset (1-bit)
    output reg [3:0] out   // 4-bit LFSR output
);

// Feedback polynomial: x^4 + x^3 + 1 (taps at bits 3 and 2)
// Calculated as XOR of bits 3 and 2, then inverted
wire feedback = ~(out[3] ^ out[2]);

// LFSR shift register operation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;    // Synchronous reset to all 0s
    end else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule