module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state
);

// Feedback calculation: XOR of MSB and second MSB, then invert
wire feedback = ~(out[3] ^ out[2]);

// On rising edge of clock, if reset is high, initialize to zero; otherwise, shift left and insert feedback at LSB
always @(posedge clk) begin
    if (rst) begin
        out <= 4'd0; // Reset to zero
    end else begin
        out <= {out[2:0], feedback}; // Shift left and insert feedback at LSB
    end
end

endmodule