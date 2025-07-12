module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoder generates control signals
    wire [2:0] booth_ctrl [3:0];
    wire [8:0] booth_pp [3:0];  // Partial products with sign extension
    
    // Booth encoding (Radix-4)
    booth_encoder_8bit encoder (
        .A(A),
        .B(B),
        .ctrl(booth_ctrl),
        .pp(booth_pp)
    );

    // Partial product generation with conditional activation
    wire [15:0] pp [3:0];
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : pp_gen
            assign pp[i] = {{(16-9){booth_pp[i][8]}}, booth_pp[i]} << (2*i);
        end
    endgenerate

    // Wallace tree reduction (3 levels)
    // Level 1: 4->3 reduction
    wire [15:0] l1_sum0, l1_carry0;
    wire [15:0] l1_sum1, l1_carry1;
    csa_16bit level1_0 (
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .sum(l1_sum0),
        .carry(l1_carry0)
    );
    csa_16bit level1_1 (
        .a(pp[3]),
        .b(l1_sum0),
        .c({l1_carry0[14:0], 1'b0}),
        .sum(l1_sum1),
        .carry(l1_carry1)
    );

    // Level 2: 3->2 reduction
    wire [15:0] l2_sum, l2_carry;
    csa_16bit level2 (
        .a(l1_sum1),
        .b({l1_carry1[14:0], 1'b0}),
        .c(16'b0),
        .sum(l2_sum),
        .carry(l2_carry)
    );

    // Final addition with hybrid adder
    hybrid_16bit_adder final_adder (
        .a(l2_sum),
        .b({l2_carry[14:0], 1'b0}),
        .sum(product)
    );

endmodule

// Radix-4 Booth encoder for 8-bit multiplier
module booth_encoder_8bit(
    input [7:0] A,
    input [7:0] B,
    output [2:0] ctrl [3:0],
    output [8:0] pp [3:0]
);
    wire [8:0] neg_A = {1'b1, ~A} + 1;  // 2's complement of A
    
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : booth_gen
            wire [2:0] b_group = (i==3) ? {B[2*i+1], B[2*i], 1'b0} : 
                                        {B[2*i+1], B[2*i], B[2*i-1]};
            
            always @(*) begin
                case (b_group)
                    3'b000, 3'b111: begin ctrl[i] = 3'b000; pp[i] = 9'b0; end
                    3'b001, 3'b010: begin ctrl[i] = 3'b001; pp[i] = {A[7], A}; end
                    3'b011:         begin ctrl[i] = 3'b010; pp[i] = {A, 1'b0}; end
                    3'b100:         begin ctrl[i] = 3'b110; pp[i] = neg_A << 1; end
                    3'b101, 3'b110: begin ctrl[i] = 3'b101; pp[i] = neg_A; end
                endcase
            end
        end
    endgenerate
endmodule

// Hybrid 16-bit adder (CLA for upper bits, RCA for lower bits)
module hybrid_16bit_adder(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Lower 8 bits use ripple carry for area efficiency
    wire [7:0] sum_low;
    wire cout;
    rca_8bit low_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(cout)
    );
    
    // Upper 8 bits use carry-lookahead for performance
    cla_8bit high_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(cout),
        .sum(sum[15:8])
    );
    
    assign sum[7:0] = sum_low;
endmodule

// 8-bit ripple carry adder
module rca_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [8:0] carry = {cout, 7'b0, cin};
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : rca_gen
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
endmodule

// 8-bit carry-lookahead adder
module cla_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum
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