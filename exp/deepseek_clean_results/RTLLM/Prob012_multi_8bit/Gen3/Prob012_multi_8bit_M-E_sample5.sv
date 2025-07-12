module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products
    wire [15:0] pp0 = { {8{1'b0}}, A } & {16{B[0]}};
    wire [15:0] pp1 = { {7{1'b0}}, A, 1'b0 } & {16{B[1]}};
    wire [15:0] pp2 = { {6{1'b0}}, A, 2'b0 } & {16{B[2]}};
    wire [15:0] pp3 = { {5{1'b0}}, A, 3'b0 } & {16{B[3]}};
    wire [15:0] pp4 = { {4{1'b0}}, A, 4'b0 } & {16{B[4]}};
    wire [15:0] pp5 = { {3{1'b0}}, A, 5'b0 } & {16{B[5]}};
    wire [15:0] pp6 = { {2{1'b0}}, A, 6'b0 } & {16{B[6]}};
    wire [15:0] pp7 = { {1{1'b0}}, A, 7'b0 } & {16{B[7]}};

    // First level of CSA reduction
    wire [15:0] sum1, carry1;
    csa csa_level1_0 (pp0, pp1, pp2, sum1, carry1);
    wire [15:0] sum2, carry2;
    csa csa_level1_1 (pp3, pp4, pp5, sum2, carry2);
    
    // Second level of CSA reduction
    wire [15:0] sum3, carry3;
    csa csa_level2_0 (sum1, {carry1[14:0], 1'b0}, sum2, sum3, carry3);
    
    // Third level combines remaining terms
    wire [15:0] sum4, carry4;
    csa csa_level3_0 (sum3, {carry3[14:0], 1'b0}, {carry2[14:0], 1'b0}, sum4, carry4);
    
    // Final addition (conventional adder)
    assign product = sum4 + {carry4[14:0], 1'b0} + pp6 + pp7;

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