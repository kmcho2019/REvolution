module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

// Initialize the state to the starting state (LSB set to 1) when reset is high
always @(posedge reset or posedge clk) begin
    if (reset) begin
        state <= 8'b0000_0001;
    end else begin
        // Shift the bits one position to the left, wrapping around from MSB to LSB
        state <= {state[6:0], state[7]};
    end
end

// Assign the current state to the output
assign out = state;

endmodule