module ring_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    output [7:0] out   // 8-bit output representing the current state
);

reg [7:0] state;      // Register to store the current state

// Initialize the state on reset
always @(posedge reset or posedge clk) begin
    if (reset) begin
        // Reset to the initial state with LSB set to 1
        state <= 8'b0000_0001;
    end else begin
        // Shift the current state to the next bit on each clock edge
        state <= {state[6:0], state[7]};
    end
end

// Assign the current state to the output
assign out = state;

endmodule