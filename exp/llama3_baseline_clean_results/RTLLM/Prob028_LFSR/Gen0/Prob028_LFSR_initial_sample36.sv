module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state; // Internal register to hold the LFSR state

assign out = state; // Output the current state

always @(posedge clk or posedge rst) begin
    if (rst) begin // If reset is high, reset the LFSR to zero
        state <= 4'b0;
    end else begin
        // Calculate the feedback by XORing the MSB and the second MSB, then inverting the result
        reg fb; // Feedback signal
        assign fb = ~(state[3] ^ state[2]);
        
        // Shift the bits to the left and insert the new feedback at the LSB
        state <= {state[2:0], fb};
    end
end

endmodule