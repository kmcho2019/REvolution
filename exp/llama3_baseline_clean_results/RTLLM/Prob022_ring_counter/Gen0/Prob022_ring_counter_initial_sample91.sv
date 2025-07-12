module ring_counter (
    input        clk,    // Clock signal
    input        reset,  // Reset signal
    output [7:0] out     // 8-bit output
);

reg [7:0] state;  // Register to hold the current state

// Initialize the output based on the state
assign out = state;

// Clock-driven always block for state update
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state to the initial state when reset is high
        state <= 8'b0000_0001;
    end else begin
        // Shift the 1 to the next position in the cyclic sequence
        // Use concatenation to handle the wrap-around
        state <= {state[6:0], state[7]};
    end
end

endmodule