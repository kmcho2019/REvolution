module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & (x[1] ^ x[0])) |  // Top row corners
               (x[3] & x[2]) |                    // Entire third row
               (x[3] & ~x[2] & (~x[1] | ~x[0])); // Bottom-left and middle
endmodule