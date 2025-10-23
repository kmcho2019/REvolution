module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // First level: 4-bit CLA blocks
    wire [1:0] G, P;  // Group Generate/Propagate
    wire [1:0] C;     // Carry between blocks
    
    // Block 0 (bits 3:0)
    wire [3:0] p0, g0;
    wire c0 = cin;
    
    // Block 1 (bits 7:4)
    wire [3:0] p1, g1;
    assign C[0] = g0[3] | (p0[3] & c0);
    
    // Generate individual bit propagate/generate
    assign p0 = a[3:0] ^ b[3:0];
    assign g0 = a[3:0] & b[3:0];
    assign p1 = a[7:4] ^ b[7:4];
    assign g1 = a[7:4] & b[7:4];
    
    // Generate group propagate/generate
    assign G[0] = g0[3] | (p0[3] & (g0[2] | (p0[2] & (g0[1] | (p0[1] & g0[0])))));
    assign P[0] = &p0;
    assign G[1] = g1[3] | (p1[3] & (g1[2] | (p1[2] & (g1[1] | (p1[1] & g1[0])))));
    assign P[1] = &p1;
    
    // Generate block carries
    assign C[1] = G[0] | (P[0] & c0);
    assign cout = G[1] | (P[1] & C[1]);
    
    // Generate sums
    assign sum[3:0] = p0 ^ {g0[2:0] | (p0[2:0] & {3{c0}}), c0};
    assign sum[7:4] = p1 ^ {g1[2:0] | (p1[2:0] & {3{C[1]}}), C[1]};

endmodule