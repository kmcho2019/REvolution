module ring_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    output [7:0] out // 8-bit output representing the current state
);

reg [7:0] state;   // Internal state register

// Initialize state to 8'b0000_0001 when reset is high
always @(posedge reset or posedge clk) begin
    if (reset) begin
        state <= 8'b0000_0001; // Reset state to initial state
    end else begin
        // Shift the current state to the next bit in the sequence
        state <= {state[6:0], state[7]}; // Wrap-around to LSB when reaching MSB
    end
end

// Assign the internal state to the output port
assign out = state;

endmodule