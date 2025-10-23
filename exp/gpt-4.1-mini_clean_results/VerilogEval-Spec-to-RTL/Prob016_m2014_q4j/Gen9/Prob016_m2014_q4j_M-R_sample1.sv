module TopModule (
    input  wire [3:0] x,
    input  wire [3:0] y,
    output wire [4:0] sum
);
    wire c1, c2, c3, c4; // Carry signals between stages

    // Stage 0 (least significant bit)
    assign sum[0] = x[0] ^ y[0];
    assign c1     = x[0] & y[0];

    // Stage 1
    assign sum[1] = x[1] ^ y[1] ^ c1;
    assign c2     = (x[1] & y[1]) | (c1 & (x[1] ^ y[1]));

    // Stage 2
    assign sum[2] = x[2] ^ y[2] ^ c2;
    assign c3     = (x[2] & y[2]) | (c2 & (x[2] ^ y[2]));

    // Stage 3 (most significant bit)
    assign sum[3] = x[3] ^ y[3] ^ c3;
    assign c4     = (x[3] & y[3]) | (c3 & (x[3] ^ y[3]));

    // Overflow bit as the final carry out
    assign sum[4] = c4;
endmodule