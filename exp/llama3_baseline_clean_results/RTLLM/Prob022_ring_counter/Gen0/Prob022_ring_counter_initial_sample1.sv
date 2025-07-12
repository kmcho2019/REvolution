module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] current_state;

// Initialize the output to the starting state when reset is high
always @(posedge reset or posedge clk) begin
    if (reset) begin
        current_state <= 8'b0000_0001; // Set the LSB to 1 and others to 0
    end else begin
        // Shift the 1 to the next bit and wrap around to LSB after MSB
        current_state <= {current_state[6:0], current_state[7]};
    end
end

// Assign the current state to the output
assign out = current_state;

endmodule