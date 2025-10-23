module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the state to the starting state when reset is high
        state <= 8'b0000_0001;
    end else begin
        // Shift the state one bit to the right, wrapping around to the MSB
        state <= {state[6:0], state[7]};
    end
end

assign out = state;

endmodule