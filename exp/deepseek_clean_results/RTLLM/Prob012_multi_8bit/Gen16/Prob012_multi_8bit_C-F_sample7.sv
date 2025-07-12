module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Power-optimized partial product generation
    wire [15:0] pp [7:0];
    assign pp[0] = B[0] ? {8'b0, A}       : 16'b0;
    assign pp[1] = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign pp[2] = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign pp[3] = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign pp[4] = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign pp[5] = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign pp[6] = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign pp[7] = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // Level 1: Reduce 8->4 using 4 CSAs
    wire [15:0] l1_sum [0:3];
    wire [15:0] l1_carry [0:3];
    
    csa csa_l1_0(.a(pp[0]), .b(pp[1]), .c(pp[2]), .sum(l1_sum[0]), .carry(l1_carry[0]));
    csa csa_l1_1(.a(pp[3]), .b(pp[4]), .c(pp[5]), .sum(l1_sum[1]), .carry(l1_carry[1]));
    assign l1_sum[2] = pp[6];
    assign l1_carry[2] = 16'b0;
    assign l1_sum[3] = pp[7];
    assign l1_carry[3] = 16'b0;

    // Level 2: Reduce 4->2 using 2 CSAs
    wire [15:0] l2_sum [0:1];
    wire [15:0] l2_carry [0:1];
    
    csa csa_l2_0(.a(l1_sum[0]), .b(l1_carry[0] << 1), .c(l1_sum[1]), .sum(l2_sum[0]), .carry(l2_carry[0]));
    csa csa_l2_1(.a(l1_sum[2]), .b(l1_carry[1] << 1), .c(l1_sum[3]), .sum(l2_sum[1]), .carry(l2_carry[1]));

    // Level 3: Final reduction to 2 vectors
    wire [15:0] final_sum, final_carry;
    csa csa_l3(.a(l2_sum[0]), .b(l2_carry[0] << 1), .c(l2_sum[1]), .sum(final_sum), .carry(final_carry));

    // Final addition with optimized hybrid adder
    hybrid_ks_adder final_adder (
        .a(final_sum),
        .b(final_carry << 1),
        .sum(product)
    );

endmodule

// Optimized Hybrid Adder (Kogge-Stone + RCA)
module hybrid_ks_adder(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Lower 8 bits use ripple carry
    wire [7:0] sum_low;
    wire cout_low;
    rca_8bit low_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(cout_low)
    );

    // Upper 8 bits use Kogge-Stone
    wire [7:0] sum_high;
    kogge_stone_8bit high_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(cout_low),
        .sum(sum_high)
    );

    assign sum = {sum_high, sum_low};
endmodule

// 8-bit Kogge-Stone Adder
module kogge_stone_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum
);
    // Generate and Propagate
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Prefix computation
    wire [7:0] G [2:0];
    wire [7:0] P [2:0];
    
    // Level 1
    assign G[0][0] = g[0];
    assign P[0][0] = p[0];
    genvar i;
    generate
        for (i=1; i<8; i=i+1) begin : level1
            assign G[0][i] = g[i];
            assign P[0][i] = p[i];
        end
        
        // Level 2 (span 1)
        for (i=0; i<7; i=i+1) begin : level2
            assign G[1][i+1] = G[0][i] | (P[0][i+1] & G[0][i+1]);
            assign P[1][i+1] = P[0][i] & P[0][i+1];
        end
        assign G[1][0] = G[0][0];
        assign P[1][0] = P[0][0];
        
        // Level 3 (span 2)
        for (i=0; i<6; i=i+1) begin : level3
            assign G[2][i+2] = G[1][i] | (P[1][i+2] & G[1][i+2]);
            assign P[2][i+2] = P[1][i] & P[1][i+2];
        end
        for (i=0; i<2; i=i+1) begin : level3_remain
            assign G[2][i] = G[1][i];
            assign P[2][i] = P[1][i];
        end
    endgenerate
    
    // Compute carries
    wire [8:0] c;
    assign c[0] = cin;
    assign c[1] = G[0][0] | (P[0][0] & cin);
    assign c[2] = G[1][1] | (P[1][1] & cin);
    assign c[3] = G[1][2] | (P[1][2] & c[1]);
    assign c[4] = G[2][3] | (P[2][3] & cin);
    assign c[5] = G[2][4] | (P[2][4] & c[1]);
    assign c[6] = G[2][5] | (P[2][5] & c[2]);
    assign c[7] = G[2][6] | (P[2][6] & c[3]);
    assign c[8] = G[2][7] | (P[2][7] & c[4]);
    
    // Compute sum
    assign sum = p ^ c[7:0];
endmodule

// Carry-Save Adder
module csa(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule

// 8-bit Ripple Carry Adder
module rca_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [8:0] c;
    assign c[0] = cin;
    
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : rca
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        end
    endgenerate
    
    assign cout = c[8];
endmodule