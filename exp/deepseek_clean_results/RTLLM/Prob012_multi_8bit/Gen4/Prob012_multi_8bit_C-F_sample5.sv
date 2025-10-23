module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth-encoded partial products (radix-4)
    wire [16:0] pp [4:0];
    
    // Booth encoder/selector
    booth_encoder_8bit encoder(
        .A(A),
        .B(B),
        .pp0(pp[0]),
        .pp1(pp[1]),
        .pp2(pp[2]),
        .pp3(pp[3]),
        .pp4(pp[4])
    );

    // First reduction stage (5:3)
    wire [16:0] sum_s1, carry_s1;
    csa_17bit stage1_0(
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .sum(sum_s1),
        .carry(carry_s1)
    );
    
    wire [16:0] sum_s1b, carry_s1b;
    csa_17bit stage1_1(
        .a(sum_s1),
        .b({carry_s1[15:0], 1'b0}),
        .c(pp[3]),
        .sum(sum_s1b),
        .carry(carry_s1b)
    );

    // Final reduction (3:2)
    wire [16:0] sum_final, carry_final;
    csa_17bit stage2(
        .a(sum_s1b),
        .b({carry_s1b[15:0], 1'b0}),
        .c(pp[4]),
        .sum(sum_final),
        .carry(carry_final)
    );

    // Hybrid adder (Kogge-Stone upper 8 bits, ripple lower 8)
    wire [15:0] final_sum;
    hybrid_16bit_adder final_adder(
        .a(sum_final[15:0]),
        .b({carry_final[14:0], 1'b0}),
        .sum(final_sum)
    );

    assign product = final_sum;

endmodule

module booth_encoder_8bit(
    input [7:0] A,
    input [7:0] B,
    output [16:0] pp0,
    output [16:0] pp1,
    output [16:0] pp2,
    output [16:0] pp3,
    output [16:0] pp4
);
    // Booth encoding groups (radix-4)
    wire [8:0] A_ext = {A[7], A};
    wire [9:0] A_neg = {~A[7], ~A, 1'b1};
    wire [9:0] A_2x = {A_ext, 1'b0};
    wire [9:0] A_neg_2x = {A_neg[8:0], 1'b0};
    
    // Generate partial products
    assign pp0 = booth_select(B[1:0], 2'b00, A_ext, A_neg[8:0], A_2x, A_neg_2x);
    assign pp1 = booth_select(B[3:1], 3'b000, A_ext, A_neg[8:0], A_2x, A_neg_2x) << 2;
    assign pp2 = booth_select(B[5:3], 3'b000, A_ext, A_neg[8:0], A_2x, A_neg_2x) << 4;
    assign pp3 = booth_select(B[7:5], 3'b000, A_ext, A_neg[8:0], A_2x, A_neg_2x) << 6;
    assign pp4 = booth_select({B[7], 1'b0}, 2'b00, A_ext, A_neg[8:0], A_2x, A_neg_2x) << 8;
endmodule

function [16:0] booth_select;
    input [2:0] bits;
    input [2:0] prev_bits;
    input [8:0] A;
    input [8:0] A_neg;
    input [9:0] A_2x;
    input [9:0] A_neg_2x;
    reg [9:0] sel;
    begin
        case ({bits, prev_bits[0]})
            4'b0000, 4'b1111: sel = 10'b0;
            4'b0001, 4'b0010, 4'b1110: sel = A_neg_2x;
            4'b0011, 4'b0100: sel = {A_neg, 1'b0};
            4'b0101, 4'b0110, 4'b1100: sel = A_2x;
            4'b0111, 4'b1000: sel = {A, 1'b0};
            default: sel = 10'b0;
        endcase
        booth_select = {{7{sel[9]}}, sel};
    end
endfunction

module csa_17bit(
    input [16:0] a,
    input [16:0] b,
    input [16:0] c,
    output [16:0] sum,
    output [16:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule

module hybrid_16bit_adder(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Lower 8 bits: ripple carry
    wire [7:0] sum_lo;
    wire cout_lo;
    ripple_8bit adder_lo(
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_lo),
        .cout(cout_lo)
    );
    
    // Upper 8 bits: Kogge-Stone
    wire [7:0] sum_hi;
    kogge_stone_8bit adder_hi(
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(cout_lo),
        .sum(sum_hi)
    );
    
    assign sum = {sum_hi, sum_lo};
endmodule

module ripple_8bit(
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
        for (i=0; i<8; i=i+1) begin
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        end
    endgenerate
    assign cout = c[8];
endmodule

module kogge_stone_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Prefix computation
    wire [7:0] g1, p1;
    wire [7:0] g2, p2;
    wire [7:0] g3, p3;
    
    // First level
    assign g1[0] = g[0];
    assign p1[0] = p[0];
    genvar i;
    generate
        for (i=1; i<8; i=i+1) begin
            assign g1[i] = g[i] | (p[i] & g[i-1]);
            assign p1[i] = p[i] & p[i-1];
        end
    
        // Second level
        assign g2[1:0] = g1[1:0];
        assign p2[1:0] = p1[1:0];
        for (i=2; i<8; i=i+1) begin
            assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
            assign p2[i] = p1[i] & p1[i-2];
        end
    
        // Third level
        assign g3[3:0] = g2[3:0];
        assign p3[3:0] = p2[3:0];
        for (i=4; i<8; i=i+1) begin
            assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
            assign p3[i] = p2[i] & p2[i-4];
        end
    endgenerate
    
    // Carry computation
    wire [8:0] c;
    assign c[0] = cin;
    assign c[1] = g3[0] | (p3[0] & cin);
    assign c[2] = g3[1] | (p3[1] & cin);
    assign c[3] = g3[2] | (p3[2] & cin);
    assign c[4] = g3[3] | (p3[3] & cin);
    assign c[5] = g3[4] | (p3[4] & cin);
    assign c[6] = g3[5] | (p3[5] & cin);
    assign c[7] = g3[6] | (p3[6] & cin);
    assign c[8] = g3[7] | (p3[7] & cin);
    
    // Sum computation
    assign sum = p ^ c[7:0];
endmodule