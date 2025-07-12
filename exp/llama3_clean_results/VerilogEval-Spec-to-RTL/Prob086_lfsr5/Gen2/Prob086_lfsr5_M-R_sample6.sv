module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

reg [4:0] next_q;

always @(*) begin
    next_q = q; // Default: no change

    // Calculate next state based on current state and taps
    next_q[4] = q[3] ^ q[0]; // Tap at position 5
    next_q[3] = q[2] ^ q[0]; // Tap at position 3
    next_q[2] = q[1];
    next_q[1] = q[0];
    next_q[0] = q[4] ^ q[3] ^ q[0]; // Update LSB based on taps and current state
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b10000; // Reset LFSR output to a non-zero state
    end else begin
        q <= next_q; // Update q on the positive edge of the clock
    end
end

endmodule