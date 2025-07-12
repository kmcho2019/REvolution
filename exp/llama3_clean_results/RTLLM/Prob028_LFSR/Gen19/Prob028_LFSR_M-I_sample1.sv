// Improved LFSR implementation
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Calculate feedback as XOR of MSB and second MSB
wire feedback = out[3] ^ out[2];

// Update shift register on the rising edge of the clock
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback at LSB
    end
end

endmodule