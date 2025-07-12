// Corrected LFSR module
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Sequential logic block to update the LFSR state
always @(posedge clk) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0000;
    end else begin // Normal operation: update LFSR state
        // Calculate feedback and shift the bits in the LFSR
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule