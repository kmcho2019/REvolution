module ring_counter(
    input clk,    // Clock signal
    input reset,  // Reset signal
    output [7:0] out  // 8-bit output
);

reg [7:0] state;  // Internal state register

// Initialize the state to its starting value
initial state = 8'b0000_0001;

// Always block to handle state transitions
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state to its initial value
        state <= 8'b0000_0001;
    end else begin
        // Shift the state to the right and wrap around to the MSB when necessary
        state <= {state[6:0], state[7]};
    end
end

// Continuous assignment to drive the output
assign out = state;

endmodule