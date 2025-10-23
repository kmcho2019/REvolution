module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [3:0] out // 4-bit output representing the current state of the LFSR
);

reg [3:0] state; // 4-bit register to store the current state
assign out = state; // Continuous assignment of the current state to the output

always @ (posedge clk) begin
    if (rst) begin // If reset is high, initialize the register to zero
        state <= 4'b0000;
    end else begin // Otherwise, shift the bits and apply feedback
        reg fb; // Feedback signal
        // Calculate the feedback by XORing the MSB and the second MSB, then invert the result
        fb = ~(state[3] ^ state[2]);
        // Shift the bits to the left and insert the new feedback value at the LSB
        state <= {state[2:0], fb};
    end
end

endmodule