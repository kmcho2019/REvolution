module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] current_state;

// Initialize the ring counter to its starting state when reset is high
always @(posedge reset or posedge clk) begin
    if (reset) begin
        // Set the LSB to 1 and all other bits to 0 when reset is high
        current_state <= 8'b0000_0001;
    end else begin
        // Shift the 1 in the current state to the next bit position on each rising edge of the clock signal
        current_state <= {current_state[6:0], current_state[7]};
    end
end

// Assign the current state to the output
assign out = current_state;

endmodule