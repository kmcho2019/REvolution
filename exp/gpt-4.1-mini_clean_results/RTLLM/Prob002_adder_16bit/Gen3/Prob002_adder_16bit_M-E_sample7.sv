module full_adder (
    input  wire a,
    input  wire b,
    input  wire Cin,
    output wire sum,
    output wire Cout
);
    assign sum  = a ^ b ^ Cin;
    assign Cout = (a & b) | (b & Cin) | (a & Cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] sum,
    output wire       Cout
);
    wire [7:0] carry;

    full_adder fa0 (.a(a[0]), .b(b[0]), .Cin(Cin),     .sum(sum[0]), .Cout(carry[0]));
    full_adder fa1 (.a(a[1]), .b(b[1]), .Cin(carry[0]), .sum(sum[1]), .Cout(carry[1]));
    full_adder fa2 (.a(a[2]), .b(b[2]), .Cin(carry[1]), .sum(sum[2]), .Cout(carry[2]));
    full_adder fa3 (.a(a[3]), .b(b[3]), .Cin(carry[2]), .sum(sum[3]), .Cout(carry[3]));
    full_adder fa4 (.a(a[4]), .b(b[4]), .Cin(carry[3]), .sum(sum[4]), .Cout(carry[4]));
    full_adder fa5 (.a(a[5]), .b(b[5]), .Cin(carry[4]), .sum(sum[5]), .Cout(carry[5]));
    full_adder fa6 (.a(a[6]), .b(b[6]), .Cin(carry[5]), .sum(sum[6]), .Cout(carry[6]));
    full_adder fa7 (.a(a[7]), .b(b[7]), .Cin(carry[6]), .sum(sum[7]), .Cout(Cout));
endmodule

module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    wire carry8;
    wire [7:0] sum_low, sum_high;

    adder_8bit low_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(sum_low),
        .Cout(carry8)
    );

    adder_8bit high_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry8),
        .sum(sum_high),
        .Cout(Co)
    );

    assign y = {sum_high, sum_low};
endmodule