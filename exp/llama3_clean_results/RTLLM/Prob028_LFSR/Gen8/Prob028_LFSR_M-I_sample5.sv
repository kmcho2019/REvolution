// Improved LFSR module with optimizations for area, power, and readability
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Internal signal for feedback calculation
reg feedback;

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0;
    end else begin // Normal operation: shift left and insert feedback
        // Calculate feedback as the inversion of the XOR of the most significant and second most significant bits
        feedback = ~(out[3] ^ out[2]);
        out <= {out[2:0], feedback}; // Shift left and insert feedback at the LSB
    end
end

endmodule