module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] state;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the state to the starting state when reset is high
        state <= 8'b0000_0001;
    end else begin
        // Shift the bits one position to the right and feed the MSB back to the LSB
        state <= {state[6:0], state[7]};
    end
end

// Use continuous assignment to assign the state to the output
assign out = state;

endmodule