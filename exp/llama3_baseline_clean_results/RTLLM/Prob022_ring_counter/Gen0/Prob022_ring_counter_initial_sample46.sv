module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to its initial state
        state <= 8'b0000_0001;
    end else begin
        // Shift the '1' to the next position, wrapping around if necessary
        state <= {state[6:0], state[7]};
    end
end

// Continuous assignment to output the current state
assign out = state;

endmodule