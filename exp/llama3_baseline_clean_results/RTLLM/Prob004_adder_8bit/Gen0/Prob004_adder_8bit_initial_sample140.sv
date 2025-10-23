module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

// Define a full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Instantiate full adders for each bit
full_adder fa0(a[0], b[0], cin, sum[0], wire carry0);
full_adder fa1(a[1], b[1], carry0, sum[1], wire carry1);
full_adder fa2(a[2], b[2], carry1, sum[2], wire carry2);
full_adder fa3(a[3], b[3], carry2, sum[3], wire carry3);
full_adder fa4(a[4], b[4], carry3, sum[4], wire carry4);
full_adder fa5(a[5], b[5], carry4, sum[5], wire carry5);
full_adder fa6(a[6], b[6], carry5, sum[6], wire carry6);
full_adder fa7(a[7], b[7], carry6, sum[7], cout);

endmodule