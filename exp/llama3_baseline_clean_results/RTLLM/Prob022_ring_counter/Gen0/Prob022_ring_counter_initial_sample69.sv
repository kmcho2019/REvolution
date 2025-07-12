module ring_counter(
    input  logic        clk,        // Clock signal
    input  logic        reset,      // Reset signal
    output logic [7:0]  out         // 8-bit output
);

logic [7:0] state;  // Internal state register

// Initialize state on reset
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001;  // Reset state to LSB set
    end else begin
        // Shift the set bit to the next position, wrapping around if necessary
        state <= {state[6:0], state[7]};  // Rotate right by one bit
    end
end

// Continuous assignment to output
assign out = state;

endmodule