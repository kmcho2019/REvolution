module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001;  // Initialize to starting state when reset is high
    end else begin
        // Shift the current state to the next bit in the sequence
        state <= {state[6:0], state[7]};
    end
end

assign out = state;  // Assign the current state to the output

endmodule