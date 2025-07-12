module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Feedback calculation: XOR of MSB (out[3]) and the second MSB (out[2]), then invert
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin  // Active high reset
        out <= 4'd0;  // Initialize the register to zero
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback at LSB
    end
end

endmodule