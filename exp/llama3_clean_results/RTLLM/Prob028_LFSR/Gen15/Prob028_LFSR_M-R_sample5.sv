// Refactored LFSR module
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Continuous assignment for feedback calculation
assign out[0] = ~(out[3] ^ out[2]);  // Invert the result of XORing out[3] and out[2]

// Single always block for shifting and feedback insertion
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        out <= {out[2:0], out[0]};  // Shift left and insert feedback at LSB
    end
end

endmodule