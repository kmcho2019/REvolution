module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to initial state
    end else begin
        state <= (state + 1) % 8; // Increment state, wrapping around if necessary
    end
end

always @(*) begin
    out = 1 << state; // Set the bit corresponding to the current state high
end

endmodule