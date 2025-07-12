module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

// Initialize the state with the LSB set to 1
initial state = 8'b0000_0001;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state to the initial value when reset is high
        state <= 8'b0000_0001;
    end else begin
        // Shift the bits to the right and wrap around to the LSB when MSB is reached
        state <= {state[6:0], state[7]};
    end
end

// Assign the current state to the output
assign out = state;

endmodule