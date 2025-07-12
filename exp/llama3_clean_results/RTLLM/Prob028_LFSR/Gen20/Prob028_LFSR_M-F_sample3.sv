// Revised LFSR implementation with traditional feedback calculation
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Initialize the register with a non-zero value to avoid the all-zero state
initial out = 4'b1000;  // Example initial value

// Use traditional feedback calculation
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        // Calculate feedback by XORing MSB and second MSB, then inverting
        out <= {out[2:0], ~(out[3] ^ out[2])};  // Shift left and insert feedback
    end
end

endmodule