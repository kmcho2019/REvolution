// Corrected LFSR implementation
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Reset and shifting logic combined
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        // Calculate feedback as XOR of MSB and second MSB, then inverted
        reg feedback;
        feedback = ~(out[3] ^ out[2]);
        out <= {out[2:0], feedback};  // Shift left and insert feedback at LSB
    end
end

endmodule