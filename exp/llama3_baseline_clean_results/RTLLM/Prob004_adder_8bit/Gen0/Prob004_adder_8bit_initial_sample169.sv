// Define a full adder module
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the 8-bit adder module
module adder_8bit(a, b, cin, sum, cout);
    input [7:0] a;
    input [7:0] b;
    input cin;
    output [7:0] sum;
    output cout;

    wire [6:0] carry;

    // Instantiate full adders for each bit position
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);
    full_adder fa1(a[1], b[1], carry[0], sum[1], carry[1]);
    full_adder fa2(a[2], b[2], carry[1], sum[2], carry[2]);
    full_adder fa3(a[3], b[3], carry[2], sum[3], carry[3]);
    full_adder fa4(a[4], b[4], carry[3], sum[4], carry[4]);
    full_adder fa5(a[5], b[5], carry[4], sum[5], carry[5]);
    full_adder fa6(a[6], b[6], carry[5], sum[6], carry[6]);
    full_adder fa7(a[7], b[7], carry[6], sum[7], cout);
endmodule