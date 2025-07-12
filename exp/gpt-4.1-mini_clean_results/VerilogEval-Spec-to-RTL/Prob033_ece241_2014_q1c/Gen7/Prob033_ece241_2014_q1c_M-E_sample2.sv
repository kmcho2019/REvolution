module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] carry;

    // Instantiate 8 full adders for each bit
    FullAdder fa0(.a(a[0]), .b(b[0]), .cin(1'b0),      .sum(s[0]), .cout(carry[0]));
    FullAdder fa1(.a(a[1]), .b(b[1]), .cin(carry[0]),   .sum(s[1]), .cout(carry[1]));
    FullAdder fa2(.a(a[2]), .b(b[2]), .cin(carry[1]),   .sum(s[2]), .cout(carry[2]));
    FullAdder fa3(.a(a[3]), .b(b[3]), .cin(carry[2]),   .sum(s[3]), .cout(carry[3]));
    FullAdder fa4(.a(a[4]), .b(b[4]), .cin(carry[3]),   .sum(s[4]), .cout(carry[4]));
    FullAdder fa5(.a(a[5]), .b(b[5]), .cin(carry[4]),   .sum(s[5]), .cout(carry[5]));
    FullAdder fa6(.a(a[6]), .b(b[6]), .cin(carry[5]),   .sum(s[6]), .cout(carry[6]));
    FullAdder fa7(.a(a[7]), .b(b[7]), .cin(carry[6]),   .sum(s[7]), .cout(carry[7]));

    // Overflow: xor of carry into MSB and carry out of MSB
    assign overflow = carry[6] ^ carry[7];
endmodule