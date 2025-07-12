module ring_counter(
    input  logic clk,         // Clock signal
    input  logic reset,       // Reset signal
    output logic [7:0] out     // 8-bit output representing the current state
);

logic [7:0] state;            // Internal state register

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize to the starting state when reset is high
        state <= 8'b0000_0001;
    end else begin
        // Shift the state to the right and wrap around when the MSB is '1'
        state <= {state[6:0], state[7]};
    end
end

// Assign the internal state directly to the output
assign out = state;

endmodule