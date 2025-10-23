module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001; // Initialize to the starting state when reset
    end else begin
        // Shift the 1 to the next bit, wrapping around to the LSB when necessary
        state <= {state[6:0], state[7]};
    end
end

assign out = state;

endmodule