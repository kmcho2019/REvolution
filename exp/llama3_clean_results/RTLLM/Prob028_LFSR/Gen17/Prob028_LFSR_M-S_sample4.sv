// Simplified LFSR module
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        // Feedback calculation: XOR of MSB and second MSB, then inverted
        out <= {out[2:0], ~(out[3] ^ out[2])};  // Shift left and insert feedback at LSB
    end
end

endmodule