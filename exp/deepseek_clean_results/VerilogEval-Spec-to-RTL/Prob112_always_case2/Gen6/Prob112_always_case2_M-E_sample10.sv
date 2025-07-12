module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Stage 1: Bit-level priority detection
    wire p0 = in[0];
    wire p1 = in[1] & ~in[0];
    wire p2 = in[2] & ~(|in[1:0]);
    wire p3 = in[3] & ~(|in[2:0]);

    // Stage 2: Position encoding
    assign pos[0] = p1 | p3;
    assign pos[1] = p2 | p3;

endmodule