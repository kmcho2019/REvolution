// Improved LFSR implementation with optimizations for better PPA
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Calculate feedback as XOR of MSB and second MSB, then inverted
// To simplify, we directly use the out[3] and out[2] without assigning to an intermediate wire
always @(posedge clk) begin
    if (rst) begin
        // Reset to zero
        out <= 4'b0;
    end else begin
        // Shift left and insert feedback at LSB
        // Feedback is calculated directly within the shift operation
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule