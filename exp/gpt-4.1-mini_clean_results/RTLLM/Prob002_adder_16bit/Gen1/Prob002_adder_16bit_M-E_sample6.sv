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

module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] sum,
    output       Cout
);
    wire c1, c2, c3;

    full_adder fa0 (.a(a[0]), .b(b[0]), .Cin(Cin),  .sum(sum[0]), .Cout(c1));
    full_adder fa1 (.a(a[1]), .b(b[1]), .Cin(c1),   .sum(sum[1]), .Cout(c2));
    full_adder fa2 (.a(a[2]), .b(b[2]), .Cin(c2),   .sum(sum[2]), .Cout(c3));
    full_adder fa3 (.a(a[3]), .b(b[3]), .Cin(c3),   .sum(sum[3]), .Cout(Cout));
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c4, c8, c12;
    wire [3:0] sum0, sum1, sum2, sum3;

    adder_4bit u0 (.a(a[3:0]),   .b(b[3:0]),   .Cin(Cin),  .sum(sum0), .Cout(c4));
    adder_4bit u1 (.a(a[7:4]),   .b(b[7:4]),   .Cin(c4),   .sum(sum1), .Cout(c8));
    adder_4bit u2 (.a(a[11:8]),  .b(b[11:8]),  .Cin(c8),   .sum(sum2), .Cout(c12));
    adder_4bit u3 (.a(a[15:12]), .b(b[15:12]), .Cin(c12),  .sum(sum3), .Cout(Co));

    assign y = {sum3, sum2, sum1, sum0};
endmodule