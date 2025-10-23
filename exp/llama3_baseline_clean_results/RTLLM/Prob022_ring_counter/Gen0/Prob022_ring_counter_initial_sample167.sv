module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

// Initialize the state to the least significant bit set high
initial state = 8'b0000_0001;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state to the least significant bit set high
        state <= 8'b0000_0001;
    end else begin
        // Shift the state one bit to the right and wrap around to the most significant bit
        state <= {state[6:0], state[7]};
    end
end

// Continuously assign the current state to the output
assign out = state;

endmodule