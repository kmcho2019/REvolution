// Refactored LFSR implementation
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] next_out;  // Temporary variable to calculate the next state

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        next_out = {out[2:0], ~(out[3] ^ out[2])};  // Calculate the next state
        out <= next_out;  // Update the output
    end
end

endmodule