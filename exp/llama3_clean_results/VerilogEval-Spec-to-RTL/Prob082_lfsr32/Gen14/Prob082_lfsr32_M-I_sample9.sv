module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        // Calculate the new MSB considering the taps
        reg [31:0] next_q;
        next_q[31] = q[30] ^ q[0]; // Tap at 31
        next_q[30:22] = q[29:21]; // No tap, shift right
        next_q[21] = q[20] ^ q[0]; // Tap at 21
        next_q[20:2] = q[19:1]; // No tap, shift right
        next_q[1] = q[0] ^ q[0]; // Tap at 1, XOR with LSB
        next_q[0] = q[31] ^ q[21] ^ q[1] ^ q[0]; // Calculate new LSB
        q <= next_q;
    end
end

endmodule