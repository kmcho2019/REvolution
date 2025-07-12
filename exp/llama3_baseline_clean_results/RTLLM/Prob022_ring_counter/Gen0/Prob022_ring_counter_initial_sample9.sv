module ring_counter(
    input   logic           clk,      // Clock signal
    input   logic           reset,    // Reset signal
    output  logic [7:0]      out      // 8-bit output
);

// Internal register to hold the current state
logic [7:0] state;

// Combinational logic to determine the next state
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the counter to its starting state when reset is high
        state <= 8'b0000_0001;
    end else begin
        // Shift the '1' bit to the next position on each clock pulse
        state <= {state[6:0], state[7]};
    end
end

// Continuous assignment to drive the output
assign out = state;

endmodule