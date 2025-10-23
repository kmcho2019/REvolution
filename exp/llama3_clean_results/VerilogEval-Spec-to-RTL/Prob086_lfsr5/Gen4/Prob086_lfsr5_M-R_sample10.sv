module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

reg [4:0] next_state;

always @(*) begin
    // Calculate next state based on current state and taps
    next_state[4] = q[3] ^ q[0];  // Tap at position 5
    next_state[3] = q[2] ^ q[0];  // Tap at position 3
    next_state[2] = q[1];
    next_state[1] = q[0];
    next_state[0] = q[4];
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b00001; // Reset LFSR output to 1
    end else begin
        q <= next_state;
    end
end

endmodule