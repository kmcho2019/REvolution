module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q[31] <= q[30]; // No tap at 31, shift right
        q[30:23] <= {q[29:22], q[21]}; // No taps, shift right
        q[22] <= q[21] ^ q[0]; // Tap at 22
        q[21:3] <= {q[20:2], q[1]}; // No taps, shift right
        q[2] <= q[1] ^ q[0]; // Tap at 2
        q[1] <= q[0] ^ q[0]; // Tap at 1, XOR with itself (unchanged)
        q[0] <= q[31]; // Feedback from MSB (bit 31) to LSB (bit 0)
    end
end

endmodule