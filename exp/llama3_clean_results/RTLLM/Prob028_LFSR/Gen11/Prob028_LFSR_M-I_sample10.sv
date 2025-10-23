// Improved LFSR module with optimized feedback mechanism
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Sequential logic block to update the LFSR state
always @(posedge clk) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0;
    end else begin // Normal operation: update LFSR state
        // Calculate feedback as the inversion of the XOR of the most significant and second most significant bits
        reg feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits in the LFSR and insert the feedback at the least significant bit (LSB)
        out <= {out[2:0], feedback};
    end
end

endmodule