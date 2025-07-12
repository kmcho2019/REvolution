module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state; // Counter to keep track of the current state

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'd0; // Reset state to 0
    end else begin
        state <= (state == 3'd7) ? 3'd0 : state + 1; // Increment state or wrap around
    end
end

always @ (*) begin
    out = 8'd0; // Initialize output to all zeros
    out[state] = 1'b1; // Set the bit corresponding to the current state high
end

endmodule