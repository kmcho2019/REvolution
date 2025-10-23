// Simplified LFSR module
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0;
    end else begin // Normal operation: shift left and insert feedback
        out <= {out[2:0], ~(out[3] ^ out[2])}; // Shift left and insert feedback at the LSB
    end
end

endmodule