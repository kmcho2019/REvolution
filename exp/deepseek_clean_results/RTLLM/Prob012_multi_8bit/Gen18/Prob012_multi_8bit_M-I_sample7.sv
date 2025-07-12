module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Clock-gated partial products
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // Wallace Tree Reduction
    // Stage 1: 8 -> 6 terms
    wire [15:0] s1_0, c1_0, s1_1, c1_1, s1_2, c1_2;
    compressor_3to2 cpr1_0 (.a(pp[0]), .b(pp[1]), .c(pp[2]), .sum(s1_0), .carry(c1_0));
    compressor_3to2 cpr1_1 (.a(pp[3]), .b(pp[4]), .c(pp[5]), .sum(s1_1), .carry(c1_1));
    assign s1_2 = pp[6];
    assign c1_2 = pp[7];

    // Stage 2: 6 -> 4 terms
    wire [15:0] s2_0, c2_0, s2_1, c2_1;
    compressor_3to2 cpr2_0 (.a(s1_0), .b(c1_0 << 1), .c(s1_1), .sum(s2_0), .carry(c2_0));
    compressor_3to2 cpr2_1 (.a(c1_1 << 1), .b(s1_2), .c(c1_2 << 1), .sum(s2_1), .carry(c2_1));

    // Stage 3: 4 -> 3 terms
    wire [15:0] s3_0, c3_0;
    wire [15:0] s3_1 = s2_1;
    compressor_3to2 cpr3_0 (.a(s2_0), .b(c2_0 << 1), .c(s2_1), .sum(s3_0), .carry(c3_0));

    // Final Carry-Select Adder
    wire [15:0] sum_lsb, sum_msb;
    wire cout_lsb, cout_msb;
    
    // Lower 8 bits (no carry-in)
    carry_select_adder #(.WIDTH(8)) csa_lsb (
        .a(s3_0[7:0]),
        .b(c3_0[7:0] << 1),
        .cin(1'b0),
        .sum(sum_lsb[7:0]),
        .cout(cout_lsb)
    );
    
    // Upper 8 bits (with carry-in)
    carry_select_adder #(.WIDTH(8)) csa_msb (
        .a(s3_0[15:8]),
        .b(c3_0[15:8] << 1),
        .cin(cout_lsb),
        .sum(sum_msb[15:8]),
        .cout(cout_msb)
    );
    
    assign product = {sum_msb[15:8], sum_lsb[7:0]} + (s3_1 << 1);

endmodule

// 3:2 Compressor (Full Adder)
module compressor_3to2 (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule

// Parameterized Carry-Select Adder
module carry_select_adder #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);
    wire [WIDTH:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : csa_loop
            wire sum0, sum1;
            wire cout0, cout1;
            
            // Calculate both possible sums
            assign sum0 = a[i] ^ b[i] ^ 1'b0;
            assign cout0 = (a[i] & b[i]) | (a[i] & 1'b0) | (b[i] & 1'b0);
            
            assign sum1 = a[i] ^ b[i] ^ 1'b1;
            assign cout1 = (a[i] & b[i]) | (a[i] & 1'b1) | (b[i] & 1'b1);
            
            // Select based on previous carry
            assign sum[i] = carry[i] ? sum1 : sum0;
            assign carry[i+1] = carry[i] ? cout1 : cout0;
        end
    endgenerate
    
    assign cout = carry[WIDTH];
endmodule