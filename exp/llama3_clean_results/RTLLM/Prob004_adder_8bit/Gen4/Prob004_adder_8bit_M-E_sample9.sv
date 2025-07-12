module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Stage 1: Calculate partial sums and carries for each bit pair
    wire [7:0] p, g;
    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];
    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];
    assign p[4] = a[4] ^ b[4];
    assign g[4] = a[4] & b[4];
    assign p[5] = a[5] ^ b[5];
    assign g[5] = a[5] & b[5];
    assign p[6] = a[6] ^ b[6];
    assign g[6] = a[6] & b[6];
    assign p[7] = a[7] ^ b[7];
    assign g[7] = a[7] & b[7];

    // Stage 2: Calculate intermediate carries
    wire c1, c2, c3, c4, c5, c6;
    assign c1 = g[0] | (p[0] & cin);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign c4 = g[3] | (p[3] & c3);
    assign c5 = g[4] | (p[4] & c4);
    assign c6 = g[5] | (p[5] & c5);

    // Stage 3: Calculate final carries
    wire c7, c8;
    assign c7 = g[6] | (p[6] & c6);
    assign c8 = g[7] | (p[7] & c7);

    // Calculate final sum
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = p[4] ^ c4;
    assign sum[5] = p[5] ^ c5;
    assign sum[6] = p[6] ^ c6;
    assign sum[7] = p[7] ^ c7;

    // Calculate final carry out
    assign cout = g[7] | (p[7] & c7);

endmodule