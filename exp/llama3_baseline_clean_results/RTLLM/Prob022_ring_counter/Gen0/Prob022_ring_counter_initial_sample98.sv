module ring_counter(
    input clk, // Clock signal
    input reset, // Reset signal
    output reg [7:0] out // 8-bit output representing the current state
);

// Internal signal to store the current state of the ring counter
reg [7:0] state;

// Initialize the state to the starting state (LSB set to 1)
initial state = 8'b0000_0001;

// Update the output based on the current state
always @(*) begin
    out = state;
end

// Update the state on each rising edge of the clock
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state to the starting state
        state <= 8'b0000_0001;
    end else begin
        // Shift the set bit (1) one position to the right
        state <= {state[6:0], state[7]};
    end
end

endmodule