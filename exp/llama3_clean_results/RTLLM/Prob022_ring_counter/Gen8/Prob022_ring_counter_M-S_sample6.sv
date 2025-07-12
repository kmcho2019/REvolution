module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state; // Internal 3-bit state to track the position

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset the state to 0
        out <= 8'b0000_0001; // Initialize out with the LSB set to 1
    end else begin
        state <= state + 1; // Increment the state
        if (state == 8) // Wrap around if state exceeds 7
            state <= 0;
        out <= 1 << state; // Set the bit corresponding to the current state high
    end
end

endmodule