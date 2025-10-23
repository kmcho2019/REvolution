// Simplified LFSR module with direct feedback calculation
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Sequential logic block to update the LFSR state and calculate feedback
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0; // Reset LFSR to all zeros
    end else begin // Normal operation: update LFSR state
        // Calculate feedback as the inverted XOR of the most significant bit and the second most significant bit
        // and then shift the bits in the LFSR, inserting the new feedback value at the LSB
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule