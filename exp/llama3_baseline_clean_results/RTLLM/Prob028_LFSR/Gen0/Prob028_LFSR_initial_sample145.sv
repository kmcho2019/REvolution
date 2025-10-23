module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [3:0] out // 4-bit output representing the current state of the LFSR
);

reg [3:0] state; // Internal 4-bit register to store the current state

always @ (posedge clk or posedge rst) begin
    if (rst) begin // If reset is high, initialize the register to zero
        state <= 4'b0000;
    end else begin // Otherwise, shift the bits and apply the feedback
        reg feedback; // Variable to hold the feedback value
        feedback = ~(state[3] ^ state[2]); // Calculate feedback by XORing MSB and second MSB, then inverting
        state <= {state[2:0], feedback}; // Shift bits left and insert feedback at LSB
    end
end

assign out = state; // Assign the current state to the output

endmodule