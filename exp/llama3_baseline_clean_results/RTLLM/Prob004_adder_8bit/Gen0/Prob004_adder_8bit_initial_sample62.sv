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

// Define the 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Declare internal wires for carries
    wire [6:0] carries;

    // Instantiate full adders
    full_adder fa0(a[0], b[0], cin, sum[0], carries[0]);
    full_adder fa1(a[1], b[1], carries[0], sum[1], carries[1]);
    full_adder fa2(a[2], b[2], carries[1], sum[2], carries[2]);
    full_adder fa3(a[3], b[3], carries[2], sum[3], carries[3]);
    full_adder fa4(a[4], b[4], carries[3], sum[4], carries[4]);
    full_adder fa5(a[5], b[5], carries[4], sum[5], carries[5]);
    full_adder fa6(a[6], b[6], carries[5], sum[6], carries[6]);
    full_adder fa7(a[7], b[7], carries[6], sum[7], cout);
endmodule