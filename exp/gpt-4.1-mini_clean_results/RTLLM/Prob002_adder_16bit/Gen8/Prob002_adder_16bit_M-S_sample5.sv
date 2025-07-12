module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] c; // internal carry signals

    // Instantiate 8 full adders in ripple carry fashion
    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(Cin),    .sum(sum[0]), .cout(c[0]));
    full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c[0]),   .sum(sum[1]), .cout(c[1]));
    full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c[1]),   .sum(sum[2]), .cout(c[2]));
    full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c[2]),   .sum(sum[3]), .cout(c[3]));
    full_adder fa4 (.a(a[4]), .b(b[4]), .cin(c[3]),   .sum(sum[4]), .cout(c[4]));
    full_adder fa5 (.a(a[5]), .b(b[5]), .cin(c[4]),   .sum(sum[5]), .cout(c[5]));
    full_adder fa6 (.a(a[6]), .b(b[6]), .cin(c[5]),   .sum(sum[6]), .cout(c[6]));
    full_adder fa7 (.a(a[7]), .b(b[7]), .cin(c[6]),   .sum(sum[7]), .cout(Cout));
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c8; // carry between lower and upper 8-bit adders

    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(c8)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule