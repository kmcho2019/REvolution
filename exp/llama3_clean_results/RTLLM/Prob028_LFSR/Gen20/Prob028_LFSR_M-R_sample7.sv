// Refactored LFSR implementation
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Reset and shifting logic combined in a single always block
always @(posedge clk) begin
    if (rst) begin
        // Reset to zero
        out <= 4'b0;
    end else begin
        // Calculate feedback as XOR of MSB and second MSB, then inverted
        reg [3:0] next_out;
        next_out = {out[2:0], ~(out[3] ^ out[2])};
        // Shift left and insert feedback at LSB
        out <= next_out;
    end
end

endmodule