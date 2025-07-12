module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products
    wire [15:0] pp [0:7];
    assign pp[0] = {8'b0, A & {8{B[0]}}};
    assign pp[1] = {7'b0, A & {8{B[1]}}, 1'b0};
    assign pp[2] = {6'b0, A & {8{B[2]}}, 2'b0};
    assign pp[3] = {5'b0, A & {8{B[3]}}, 3'b0};
    assign pp[4] = {4'b0, A & {8{B[4]}}, 4'b0};
    assign pp[5] = {3'b0, A & {8{B[5]}}, 5'b0};
    assign pp[6] = {2'b0, A & {8{B[6]}}, 6'b0};
    assign pp[7] = {1'b0, A & {8{B[7]}}, 7'b0};

    // First level of CSA reduction (4 to 3)
    wire [15:0] sum1, carry1;
    csa csa1(.a(pp[0]), .b(pp[1]), .c(pp[2]), .sum(sum1), .carry(carry1));
    wire [15:0] sum2, carry2;
    csa csa2(.a(pp[3]), .b(pp[4]), .c(pp[5]), .sum(sum2), .carry(carry2));
    
    // Second level of CSA reduction (3 to 2)
    wire [15:0] sum3, carry3;
    csa csa3(.a(sum1), .b(carry1<<1), .c(pp[6]), .sum(sum3), .carry(carry3));
    wire [15:0] sum4, carry4;
    csa csa4(.a(sum2), .b(carry2<<1), .c(pp[7]), .sum(sum4), .carry(carry4));

    // Final level of CSA reduction (2 vectors)
    wire [15:0] sum5, carry5;
    csa csa5(.a(sum3), .b(carry3<<1), .c(sum4), .sum(sum5), .carry(carry5));

    // Final addition (carry-propagate adder)
    assign product = sum5 + (carry5 << 1) + (carry4 << 1);

endmodule

// Carry-Save Adder module
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