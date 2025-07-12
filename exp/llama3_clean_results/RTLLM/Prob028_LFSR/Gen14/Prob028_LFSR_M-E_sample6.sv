// Novel LFSR module using a multiplexer, shift register, and feedback logic
module LFSR_MUX(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

reg [3:0] shift_reg;  // Internal shift register
reg       feedback;   // Feedback signal

// Feedback logic block
always @(*) begin
    feedback = ~(out[3] ^ out[2]);  // Invert the result of XORing out[3] and out[2]
end

// Multiplexer to select between the current state and the feedback value
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback at LSB
    end
end

endmodule