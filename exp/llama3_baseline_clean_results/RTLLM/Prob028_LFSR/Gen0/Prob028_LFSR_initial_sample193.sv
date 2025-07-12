module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state; // Internal register to hold the state of the LFSR
assign out = state; // Output is the current state of the LFSR

always @ (posedge clk or posedge rst) begin
    if (rst) begin // If reset is high, initialize the register to zero
        state <= 4'b0000;
    end else begin // If reset is low, shift the bits and apply feedback
        // Calculate the feedback by XORing the MSB and the second MSB, then inverting the result
        reg fb;
        assign fb = ~(state[3] ^ state[2]);
        // Shift the bits left and insert the new feedback at the LSB
        state <= {state[2:0], fb};
    end
end

endmodule