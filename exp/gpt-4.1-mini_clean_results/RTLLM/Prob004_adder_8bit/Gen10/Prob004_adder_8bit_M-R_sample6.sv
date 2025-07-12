// Single bit full adder module
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 8-bit ripple carry adder built from 8 bit_full_adders
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [8:0] c;  // carry chain: c[0] = cin, c[8] = cout
    assign c[0] = cin;

    // Instantiate full adders for each bit
    bit_full_adder fa0 (.a(a[0]), .b(b[0]), .cin(c[0]), .sum(sum[0]), .cout(c[1]));
    bit_full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c[1]), .sum(sum[1]), .cout(c[2]));
    bit_full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c[2]), .sum(sum[2]), .cout(c[3]));
    bit_full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c[3]), .sum(sum[3]), .cout(c[4]));
    bit_full_adder fa4 (.a(a[4]), .b(b[4]), .cin(c[4]), .sum(sum[4]), .cout(c[5]));
    bit_full_adder fa5 (.a(a[5]), .b(b[5]), .cin(c[5]), .sum(sum[5]), .cout(c[6]));
    bit_full_adder fa6 (.a(a[6]), .b(b[6]), .cin(c[6]), .sum(sum[6]), .cout(c[7]));
    bit_full_adder fa7 (.a(a[7]), .b(b[7]), .cin(c[7]), .sum(sum[7]), .cout(c[8]));

    assign cout = c[8];
endmodule