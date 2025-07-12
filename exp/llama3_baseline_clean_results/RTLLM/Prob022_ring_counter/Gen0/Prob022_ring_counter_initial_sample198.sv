module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

initial state = 8'b0000_0001;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001; // Reset to initial state
    end else begin
        // Shift the set bit to the next position
        state <= {state[6:0], state[7]};
    end
end

assign out = state;

endmodule