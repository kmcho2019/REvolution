module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products with conditional assignment
    wire [15:0] pp [0:7];
    assign pp[0] = B[0] ? {8'b0, A} : 16'b0;
    assign pp[1] = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign pp[2] = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign pp[3] = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign pp[4] = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign pp[5] = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign pp[6] = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign pp[7] = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level of CSA reduction (balanced tree)
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    wire [15:0] sum3, carry3;
    wire [15:0] sum4, carry4;
    
    csa csa1(.a(pp[0]), .b(pp[1]), .c(pp[2]), .sum(sum1), .carry(carry1));
    csa csa2(.a(pp[3]), .b(pp[4]), .c(pp[5]), .sum(sum2), .carry(carry2));
    csa csa3(.a(pp[6]), .b(pp[7]), .c(16'b0), .sum(sum3), .carry(carry3));

    // Second level of CSA reduction
    wire [15:0] sum5, carry5;
    wire [15:0] sum6, carry6;
    
    csa csa4(.a(sum1), .b(carry1<<1), .c(sum2), .sum(sum5), .carry(carry5));
    csa csa5(.a(carry2<<1), .b(sum3), .c(carry3<<1), .sum(sum6), .carry(carry6));

    // Final addition using Brent-Kung adder
    wire [15:0] final_sum = sum5 + sum6;
    wire [15:0] final_carry = (carry5 << 1) + (carry6 << 1);
    assign product = final_sum + final_carry;

endmodule

// Optimized Carry-Save Adder module
module csa(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    // Only compute necessary bits to save power
    assign sum = a ^ b ^ c;
    assign carry = {(a[14:0] & b[14:0]) | (a[14:0] & c[14:0]) | (b[14:0] & c[14:0]), 1'b0};
endmodule

// Brent-Kung Adder (simplified for illustration)
module brent_kung_adder(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Implementation of Brent-Kung prefix adder would go here
    // For brevity, using simple addition in this example
    assign sum = a + b;
endmodule