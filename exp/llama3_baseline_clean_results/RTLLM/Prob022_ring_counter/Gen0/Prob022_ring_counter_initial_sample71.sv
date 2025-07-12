module ring_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    output [7:0] out // 8-bit output representing the current state
);

reg [7:0] state;    // 8-bit register to store the current state

// Initialize the counter to its starting state with the LSB set to 1
initial begin
    state = 8'b0000_0001;
end

// On each rising edge of the clock signal, shift the current state to the next bit
always @(posedge clk) begin
    if (reset) begin
        state <= 8'b0000_0001;  // Reset the counter to its starting state
    end else begin
        state <= {state[6:0], state[7]};  // Shift the current state to the next bit
    end
end

// Assign the current state to the output
assign out = state;

endmodule