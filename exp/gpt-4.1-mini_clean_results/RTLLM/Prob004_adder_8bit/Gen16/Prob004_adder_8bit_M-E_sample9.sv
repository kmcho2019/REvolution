module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    // Generate and propagate signals for each bit
    wire [7:0] g; // generate
    wire [7:0] p; // propagate
    wire [7:0] c; // carries, c[0] is carry-in
    
    assign g = a & b;
    assign p = a ^ b;
    assign c[0] = cin;

    // Level 1 prefix (distance 1)
    wire [7:0] g1, p1;
    assign g1[0] = g[0];
    assign p1[0] = p[0];
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : level1
            assign g1[i] = g[i] | (p[i] & g[i-1]);
            assign p1[i] = p[i] & p[i-1];
        end
    endgenerate

    // Level 2 prefix (distance 2)
    wire [7:0] g2, p2;
    assign g2[0] = g1[0];
    assign p2[0] = p1[0];
    assign g2[1] = g1[1];
    assign p2[1] = p1[1];
    generate
        for (i = 2; i < 8; i = i + 1) begin : level2
            assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
            assign p2[i] = p1[i] & p1[i-2];
        end
    endgenerate

    // Level 3 prefix (distance 4)
    wire [7:0] g3, p3;
    assign g3[0] = g2[0];
    assign p3[0] = p2[0];
    assign g3[1] = g2[1];
    assign p3[1] = p2[1];
    assign g3[2] = g2[2];
    assign p3[2] = p2[2];
    assign g3[3] = g2[3];
    assign p3[3] = p2[3];
    generate
        for (i = 4; i < 8; i = i + 1) begin : level3
            assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
            assign p3[i] = p2[i] & p2[i-4];
        end
    endgenerate

    // Compute carry for each bit
    // According to Kogge-Stone structure,
    // carry-in to bit i+1 = g3[i]
    assign c[1] = g3[0];
    assign c[2] = g3[1];
    assign c[3] = g3[2];
    assign c[4] = g3[3];
    assign c[5] = g3[4];
    assign c[6] = g3[5];
    assign c[7] = g3[6];
    // Carry-out for bit 7
    assign cout = g3[7];

    // Sum bits: sum[i] = p[i] ^ c[i]
    assign sum = p ^ c[7:0];

endmodule