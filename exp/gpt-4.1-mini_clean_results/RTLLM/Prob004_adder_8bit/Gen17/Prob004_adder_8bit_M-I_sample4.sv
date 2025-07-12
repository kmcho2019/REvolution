// Black cell: calculates group propagate and generate for pairs
module black_cell (
    input  wire p_k,
    input  wire g_k,
    input  wire p_j,
    input  wire g_j,
    output wire p_out,
    output wire g_out
);
    assign p_out = p_k & p_j;
    assign g_out = g_k | (p_k & g_j);
endmodule

// Grey cell: calculates group generate only, used at the ends of prefix trees
module grey_cell (
    input  wire g_k,
    input  wire p_k,
    input  wire g_j,
    output wire g_out
);
    assign g_out = g_k | (p_k & g_j);
endmodule

// Single bit full adder: provides propagate and generate signals
module bit_full_adder (
    input  wire a,
    input  wire b,
    output wire p, // propagate
    output wire g  // generate
);
    assign p = a ^ b;
    assign g = a & b;
endmodule

// 8-bit adder using Kogge-Stone parallel prefix carry generation
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] p, g;        // bit-level propagate and generate
    wire [7:0] c;           // carry-in for each bit (c[0] = cin)
    
    // Stage 0: initial propagate and generate
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_pg
            bit_full_adder bfa (
                .a(a[i]),
                .b(b[i]),
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Assign initial carry-in
    assign c[0] = cin;

    // Stage 1: Level 1 of prefix tree (distance 1)
    wire p_level1[7:0];
    wire g_level1[7:0];
    assign p_level1[0] = p[0];
    assign g_level1[0] = g[0];
    // For bit 1:
    black_cell bc1_1 (.p_k(p[1]), .g_k(g[1]), .p_j(p[0]), .g_j(g[0]), .p_out(p_level1[1]), .g_out(g_level1[1]));
    // bit 2:
    black_cell bc1_2 (.p_k(p[2]), .g_k(g[2]), .p_j(p[1]), .g_j(g[1]), .p_out(p_level1[2]), .g_out(g_level1[2]));
    // bit 3:
    black_cell bc1_3 (.p_k(p[3]), .g_k(g[3]), .p_j(p[2]), .g_j(g[2]), .p_out(p_level1[3]), .g_out(g_level1[3]));
    // bit 4:
    black_cell bc1_4 (.p_k(p[4]), .g_k(g[4]), .p_j(p[3]), .g_j(g[3]), .p_out(p_level1[4]), .g_out(g_level1[4]));
    // bit 5:
    black_cell bc1_5 (.p_k(p[5]), .g_k(g[5]), .p_j(p[4]), .g_j(g[4]), .p_out(p_level1[5]), .g_out(g_level1[5]));
    // bit 6:
    black_cell bc1_6 (.p_k(p[6]), .g_k(g[6]), .p_j(p[5]), .g_j(g[5]), .p_out(p_level1[6]), .g_out(g_level1[6]));
    // bit 7:
    black_cell bc1_7 (.p_k(p[7]), .g_k(g[7]), .p_j(p[6]), .g_j(g[6]), .p_out(p_level1[7]), .g_out(g_level1[7]));

    // Stage 2: Level 2 of prefix tree (distance 2)
    wire p_level2[7:0];
    wire g_level2[7:0];
    assign p_level2[0] = p_level1[0];
    assign g_level2[0] = g_level1[0];
    assign p_level2[1] = p_level1[1];
    assign g_level2[1] = g_level1[1];
    black_cell bc2_2 (.p_k(p_level1[2]), .g_k(g_level1[2]), .p_j(p_level1[0]), .g_j(g_level1[0]), .p_out(p_level2[2]), .g_out(g_level2[2]));
    black_cell bc2_3 (.p_k(p_level1[3]), .g_k(g_level1[3]), .p_j(p_level1[1]), .g_j(g_level1[1]), .p_out(p_level2[3]), .g_out(g_level2[3]));
    black_cell bc2_4 (.p_k(p_level1[4]), .g_k(g_level1[4]), .p_j(p_level1[2]), .g_j(g_level1[2]), .p_out(p_level2[4]), .g_out(g_level2[4]));
    black_cell bc2_5 (.p_k(p_level1[5]), .g_k(g_level1[5]), .p_j(p_level1[3]), .g_j(g_level1[3]), .p_out(p_level2[5]), .g_out(g_level2[5]));
    black_cell bc2_6 (.p_k(p_level1[6]), .g_k(g_level1[6]), .p_j(p_level1[4]), .g_j(g_level1[4]), .p_out(p_level2[6]), .g_out(g_level2[6]));
    black_cell bc2_7 (.p_k(p_level1[7]), .g_k(g_level1[7]), .p_j(p_level1[5]), .g_j(g_level1[5]), .p_out(p_level2[7]), .g_out(g_level2[7]));

    // Stage 3: Level 3 of prefix tree (distance 4)
    wire p_level3[7:0];
    wire g_level3[7:0];
    assign p_level3[0] = p_level2[0];
    assign g_level3[0] = g_level2[0];
    assign p_level3[1] = p_level2[1];
    assign g_level3[1] = g_level2[1];
    assign p_level3[2] = p_level2[2];
    assign g_level3[2] = g_level2[2];
    assign p_level3[3] = p_level2[3];
    assign g_level3[3] = g_level2[3];
    black_cell bc3_4 (.p_k(p_level2[4]), .g_k(g_level2[4]), .p_j(p_level2[0]), .g_j(g_level2[0]), .p_out(p_level3[4]), .g_out(g_level3[4]));
    black_cell bc3_5 (.p_k(p_level2[5]), .g_k(g_level2[5]), .p_j(p_level2[1]), .g_j(g_level2[1]), .p_out(p_level3[5]), .g_out(g_level3[5]));
    black_cell bc3_6 (.p_k(p_level2[6]), .g_k(g_level2[6]), .p_j(p_level2[2]), .g_j(g_level2[2]), .p_out(p_level3[6]), .g_out(g_level3[6]));
    black_cell bc3_7 (.p_k(p_level2[7]), .g_k(g_level2[7]), .p_j(p_level2[3]), .g_j(g_level2[3]), .p_out(p_level3[7]), .g_out(g_level3[7]));

    // Final carry signals using grey cells and cin
    wire [7:1] carry;
    // c[0] = cin input already assigned
    
    // c[1] = g[0] + p[0]*cin
    grey_cell gc_1 (.g_k(g[0]), .p_k(p[0]), .g_j(cin), .g_out(carry[1]));
    // c[2] = g_level1[1] + p_level1[1]*cin
    grey_cell gc_2 (.g_k(g_level1[1]), .p_k(p_level1[1]), .g_j(cin), .g_out(carry[2]));
    // c[3] = g_level2[2] + p_level2[2]*cin
    grey_cell gc_3 (.g_k(g_level2[2]), .p_k(p_level2[2]), .g_j(cin), .g_out(carry[3]));
    // c[4] = g_level3[3] + p_level3[3]*cin
    grey_cell gc_4 (.g_k(g_level3[3]), .p_k(p_level3[3]), .g_j(cin), .g_out(carry[4]));
    // c[5] = g_level3[4] + p_level3[4]*cin
    grey_cell gc_5 (.g_k(g_level3[4]), .p_k(p_level3[4]), .g_j(cin), .g_out(carry[5]));
    // c[6] = g_level3[5] + p_level3[5]*cin
    grey_cell gc_6 (.g_k(g_level3[5]), .p_k(p_level3[5]), .g_j(cin), .g_out(carry[6]));
    // c[7] = g_level3[6] + p_level3[6]*cin
    grey_cell gc_7 (.g_k(g_level3[6]), .p_k(p_level3[6]), .g_j(cin), .g_out(carry[7]));

    // c[8] (cout) = g_level3[7] + p_level3[7]*cin
    wire c8;
    grey_cell gc_8 (.g_k(g_level3[7]), .p_k(p_level3[7]), .g_j(cin), .g_out(c8));

    // Assign all carry bits to c array for sum calculation
    assign c[1] = carry[1];
    assign c[2] = carry[2];
    assign c[3] = carry[3];
    assign c[4] = carry[4];
    assign c[5] = carry[5];
    assign c[6] = carry[6];
    assign c[7] = carry[7];

    assign cout = c8;

    // Final sum bits: sum[i] = p[i] XOR c[i]
    generate
        for (i=0; i<8; i=i+1) begin : gen_sum
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

endmodule