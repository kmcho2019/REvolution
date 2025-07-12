// 1-bit full adder module
module full_adder_1bit (
    input  wire a,    // 1-bit input A
    input  wire b,    // 1-bit input B
    input  wire cin,  // Carry-in
    output wire sum,  // Sum output
    output wire cout  // Carry-out
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 8-bit adder using manual instantiation of full adders
module adder_8bit (
    input  wire [7:0] a,    // 8-bit input operand A
    input  wire [7:0] b,    // 8-bit input operand B
    input  wire       cin,  // Carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // Carry-out output
);
    wire c1, c2, c3, c4, c5, c6, c7;

    full_adder_1bit fa0 (.a(a[0]), .b(b[0]), .cin(cin),  .sum(sum[0]), .cout(c1));
    full_adder_1bit fa1 (.a(a[1]), .b(b[1]), .cin(c1),   .sum(sum[1]), .cout(c2));
    full_adder_1bit fa2 (.a(a[2]), .b(b[2]), .cin(c2),   .sum(sum[2]), .cout(c3));
    full_adder_1bit fa3 (.a(a[3]), .b(b[3]), .cin(c3),   .sum(sum[3]), .cout(c4));
    full_adder_1bit fa4 (.a(a[4]), .b(b[4]), .cin(c4),   .sum(sum[4]), .cout(c5));
    full_adder_1bit fa5 (.a(a[5]), .b(b[5]), .cin(c5),   .sum(sum[5]), .cout(c6));
    full_adder_1bit fa6 (.a(a[6]), .b(b[6]), .cin(c6),   .sum(sum[6]), .cout(c7));
    full_adder_1bit fa7 (.a(a[7]), .b(b[7]), .cin(c7),   .sum(sum[7]), .cout(cout));

endmodule