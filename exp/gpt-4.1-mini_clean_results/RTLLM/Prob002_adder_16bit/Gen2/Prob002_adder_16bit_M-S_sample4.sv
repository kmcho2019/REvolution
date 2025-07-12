module full_adder (
    input  a,
    input  b,
    input  Cin,
    output sum,
    output Cout
);
    assign sum  = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] c;
    // c[0] is carry out of bit 0, etc.
    full_adder fa0 (.a(a[0]), .b(b[0]), .Cin(Cin),   .sum(sum[0]), .Cout(c[0]));
    full_adder fa1 (.a(a[1]), .b(b[1]), .Cin(c[0]),  .sum(sum[1]), .Cout(c[1]));
    full_adder fa2 (.a(a[2]), .b(b[2]), .Cin(c[1]),  .sum(sum[2]), .Cout(c[2]));
    full_adder fa3 (.a(a[3]), .b(b[3]), .Cin(c[2]),  .sum(sum[3]), .Cout(c[3]));
    full_adder fa4 (.a(a[4]), .b(b[4]), .Cin(c[3]),  .sum(sum[4]), .Cout(c[4]));
    full_adder fa5 (.a(a[5]), .b(b[5]), .Cin(c[4]),  .sum(sum[5]), .Cout(c[5]));
    full_adder fa6 (.a(a[6]), .b(b[6]), .Cin(c[5]),  .sum(sum[6]), .Cout(c[6]));
    full_adder fa7 (.a(a[7]), .b(b[7]), .Cin(c[6]),  .sum(sum[7]), .Cout(Cout));
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c8;

    adder_8bit u0 (.a(a[7:0]),   .b(b[7:0]),   .Cin(Cin), .sum(y[7:0]),   .Cout(c8));
    adder_8bit u1 (.a(a[15:8]),  .b(b[15:8]),  .Cin(c8),  .sum(y[15:8]),  .Cout(Co));
endmodule