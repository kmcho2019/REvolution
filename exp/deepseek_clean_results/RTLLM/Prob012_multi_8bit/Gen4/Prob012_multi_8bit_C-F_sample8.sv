module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoder (radix-4) to reduce partial products
    wire [8:0] B_ext = {B, 1'b0};
    wire [2:0] booth_sel [4:0];
    wire [15:0] pp [4:0];
    
    // Generate booth select signals and pre-shifted versions of A
    wire [15:0] A_neg = {8'b0, ~A + 1'b1};
    wire [15:0] A_2x = {7'b0, A, 1'b0};
    wire [15:0] A_neg_2x = {7'b0, ~A + 1'b1, 1'b0};
    
    // Booth encoding and partial product selection
    genvar i;
    generate
        for (i=0; i<5; i=i+1) begin : booth_pp
            assign booth_sel[i] = B_ext[2*i+2:2*i];
            
            always @(*) begin
                case (booth_sel[i])
                    3'b000, 3'b111: pp[i] = 16'b0;
                    3'b001, 3'b010: pp[i] = {8'b0, A} << (2*i);
                    3'b011:         pp[i] = A_2x << (2*i);
                    3'b100:         pp[i] = A_neg_2x << (2*i);
                    3'b101, 3'b110: pp[i] = {8'b0, ~A + 1'b1} << (2*i);
                endcase
            end
        end
    endgenerate

    // Wallace tree reduction
    // Stage 1: 3:2 CSA for first 3 partial products
    wire [15:0] sum1, carry1;
    csa_16bit stage1 (
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .sum(sum1),
        .carry(carry1)
    );

    // Stage 2: 3:2 CSA for next 2 partial products and carry
    wire [15:0] sum2, carry2;
    csa_16bit stage2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(pp[3]),
        .sum(sum2),
        .carry(carry2)
    );

    // Final addition with carry-select adder
    wire [15:0] final_operand = pp[4] + {carry2[14:0], 1'b0};
    hybrid_adder_16bit final_adder (
        .a(sum2),
        .b(final_operand),
        .sum(product)
    );

endmodule

// Optimized 16-bit hybrid adder (CLA + carry-select)
module hybrid_adder_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // CLA for lower 8 bits
    wire [7:0] sum_low;
    wire cout_low;
    cla_8bit low_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(cout_low)
    );

    // Carry-select for upper 8 bits
    wire [7:0] sum_high0, sum_high1;
    cla_8bit high_adder0 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b0),
        .sum(sum_high0),
        .cout()
    );
    
    cla_8bit high_adder1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b1),
        .sum(sum_high1),
        .cout()
    );
    
    assign sum = {cout_low ? sum_high1 : sum_high0, sum_low};
endmodule

// 8-bit CLA module for hybrid adder
module cla_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    wire [7:0] c;
    
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign cout = g[7] | (p[7] & c[7]);
    
    assign sum = p ^ c;
endmodule

// Basic 16-bit CSA remains the same
module csa_16bit(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule