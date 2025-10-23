module TopModule (
    input clk,
    input reset,
    output reg [4:0] q = 1
);

always @(posedge clk)
    q <= reset ? 5'b00001 : {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
    // MSB gets feedback (position 5)
    // Tap at position 3 (q[3] XOR with q[0])
    // Other bits shift right

endmodule