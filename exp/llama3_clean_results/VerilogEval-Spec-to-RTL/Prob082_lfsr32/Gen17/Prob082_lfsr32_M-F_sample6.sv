module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_state;

always @(*) begin
    next_state = q;
    // Implement taps
    next_state[31] = q[0]; // Most significant bit
    next_state[21] = q[21] ^ q[0]; // Tap at position 22
    next_state[1] = q[1] ^ q[0]; // Tap at position 2
    next_state[0] = q[0]; // LSB, always stays the same
end

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {next_state[0], next_state[31:1]};
    end
end

endmodule