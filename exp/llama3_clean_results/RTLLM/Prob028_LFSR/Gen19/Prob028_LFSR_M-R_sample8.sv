// Refactored LFSR implementation
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Calculate feedback as XOR of MSB and second MSB, then inverted
assign out[0] = ~(out[3] ^ out[2]);

// Reset logic
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end
end

// Shifting logic
always @(posedge clk) begin
    if (!rst) begin
        out <= {out[2:0], out[0]};  // Shift left and insert feedback at LSB
    end
end

endmodule