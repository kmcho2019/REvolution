module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate and Propagate signals for 4-bit blocks
    wire [1:0] G, P;
    wire [1:0] C;  // Carry between blocks

    // First 4-bit block (bits 3:0)
    wire [3:0] g0, p0;
    assign g0 = a[3:0] & b[3:0];
    assign p0 = a[3:0] ^ b[3:0];
    assign G[0] = g0[3] | (p0[3] & (g0[2] | (p0[2] & (g0[1] | (p0[1] & g0[0])))));
    assign P[0] = p0[3] & p0[2] & p0[1] & p0[0];
    assign C[0] = G[0] | (P[0] & cin);

    // Second 4-bit block (bits 7:4)
    wire [3:0] g1, p1;
    assign g1 = a[7:4] & b[7:4];
    assign p1 = a[7:4] ^ b[7:4];
    assign G[1] = g1[3] | (p1[3] & (g1[2] | (p1[2] & (g1[1] | (p1[1] & g1[0])))));
    assign P[1] = p1[3] & p1[2] & p1[1] & p1[0];
    assign C[1] = G[1] | (P[1] & C[0]);
    assign cout = C[1];

    // Sum computation (parallel)
    assign sum[0] = p0[0] ^ cin;
    assign sum[1] = p0[1] ^ (g0[0] | (p0[0] & cin));
    assign sum[2] = p0[2] ^ (g0[1] | (p0[1] & (g0[0] | (p0[0] & cin))));
    assign sum[3] = p0[3] ^ (g0[2] | (p0[2] & (g0[1] | (p0[1] & (g0[0] | (p0[0] & cin))))));
    
    assign sum[4] = p1[0] ^ C[0];
    assign sum[5] = p1[1] ^ (g1[0] | (p1[0] & C[0]));
    assign sum[6] = p1[2] ^ (g1[1] | (p1[1] & (g1[0] | (p1[0] & C[0]))));
    assign sum[7] = p1[3] ^ (g1[2] | (p1[2] & (g1[1] | (p1[1] & (g1[0] | (p1[0] & C[0])))));

endmodule