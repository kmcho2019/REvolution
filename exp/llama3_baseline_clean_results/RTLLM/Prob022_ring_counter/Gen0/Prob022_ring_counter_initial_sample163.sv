module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize to the starting state when reset is high
        state <= 8'b0000_0001;
    end else begin
        // Shift the state one position to the right on each clock cycle
        state <= {state[6:0], state[7]};
    end
end

assign out = state;

endmodule