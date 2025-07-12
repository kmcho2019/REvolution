module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Generate partial products only when B[i] is 1
    wire [15:0] pp [7:0];
    assign pp[0] = B[0] ? { {8{1'b0}}, A } : 16'b0;
    assign pp[1] = B[1] ? { {7{1'b0}}, A, 1'b0 } : 16'b0;
    assign pp[2] = B[2] ? { {6{1'b0}}, A, 2'b0 } : 16'b0;
    assign pp[3] = B[3] ? { {5{1'b0}}, A, 3'b0 } : 16'b0;
    assign pp[4] = B[4] ? { {4{1'b0}}, A, 4'b0 } : 16'b0;
    assign pp[5] = B[5] ? { {3{1'b0}}, A, 5'b0 } : 16'b0;
    assign pp[6] = B[6] ? { {2{1'b0}}, A, 6'b0 } : 16'b0;
    assign pp[7] = B[7] ? { {1{1'b0}}, A, 7'b0 } : 16'b0;

    // First level CSA reduction (process 3 partial products at a time)
    wire [15:0] sum1, carry1;
    csa csa_level1_0 (pp[0], pp[1], pp[2], sum1, carry1);
    
    // Second level CSA reduction
    wire [15:0] sum2, carry2;
    csa csa_level2_0 (pp[3], pp[4], pp[5], sum2, carry2);
    
    // Third level combines results from first two levels
    wire [15:0] sum3, carry3;
    csa csa_level3_0 (sum1, {carry1[14:0], 1'b0}, sum2, sum3, carry3);
    
    // Fourth level combines remaining terms
    wire [15:0] sum4, carry4;
    csa csa_level4_0 (sum3, {carry3[14:0], 1'b0}, {carry2[14:0], 1'b0}, sum4, carry4);
    
    // Final addition using carry-lookahead adder
    wire [15:0] final_sum;
    cla_adder final_adder (
        .a(sum4),
        .b({carry4[14:0], 1'b0} + pp[6] + pp[7]),
        .sum(final_sum)
    );
    
    always @(*) begin
        product = final_sum;
    end

endmodule

// Carry-Save Adder module
module csa (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule

// 16-bit Carry-Lookahead Adder
module cla_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [16:0] carry;
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : adder
            wire p = a[i] ^ b[i];
            wire g = a[i] & b[i];
            assign carry[i+1] = g | (p & carry[i]);
            assign sum[i] = p ^ carry[i];
        end
    endgenerate
endmodule