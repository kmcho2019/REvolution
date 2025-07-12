module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// First level: 4-bit adders
wire [3:0] sum_l;
wire [3:0] sum_u;
wire      carry_l;
wire      carry_u;

adder_4bit adder_l(
    .a(a[3:0]),
    .b(b[3:0]),
    .cin(cin),
    .sum(sum_l),
    .cout(carry_l)
);

adder_4bit adder_u(
    .a(a[7:4]),
    .b(b[7:4]),
    .cin(carry_l),
    .sum(sum_u),
    .cout(carry_u)
);

// Second level: 2-bit adders
wire [1:0] sum_l2;
wire [1:0] sum_u2;
wire      carry_l2;
wire      carry_u2;

adder_2bit adder_l2(
    .a(sum_l[1:0]),
    .b(sum_u[1:0]),
    .cin(carry_l),
    .sum(sum_l2),
    .cout(carry_l2)
);

adder_2bit adder_u2(
    .a(sum_l[3:2]),
    .b(sum_u[3:2]),
    .cin(carry_u),
    .sum(sum_u2),
    .cout(carry_u2)
);

// Third level: final 2-bit adder
wire [1:0] sum_f;
wire      carry_f;

adder_2bit adder_f(
    .a(sum_l2),
    .b(sum_u2),
    .cin(carry_u2),
    .sum(sum_f),
    .cout(carry_f)
);

// Assign outputs
assign sum[7:0] = {sum_u[3:2], sum_l[3:2], sum_f};
assign cout = carry_f;

endmodule

module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);

// Calculate sum and carry using full adders
wire [3:0] sum_temp;
wire [2:0] carry_temp;

full_adder fa0(
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum_temp[0]),
    .cout(carry_temp[0])
);

full_adder fa1(
    .a(a[1]),
    .b(b[1]),
    .cin(carry_temp[0]),
    .sum(sum_temp[1]),
    .cout(carry_temp[1])
);

full_adder fa2(
    .a(a[2]),
    .b(b[2]),
    .cin(carry_temp[1]),
    .sum(sum_temp[2]),
    .cout(carry_temp[2])
);

full_adder fa3(
    .a(a[3]),
    .b(b[3]),
    .cin(carry_temp[2]),
    .sum(sum_temp[3]),
    .cout(cout)
);

assign sum[3:0] = sum_temp[3:0];

endmodule

module adder_2bit(
    input   [1:0] a,
    input   [1:0] b,
    input       cin,
    output  [1:0] sum,
    output      cout
);

// Calculate sum and carry using full adders
wire [1:0] sum_temp;
wire      carry_temp;

full_adder fa0(
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum_temp[0]),
    .cout(carry_temp)
);

full_adder fa1(
    .a(a[1]),
    .b(b[1]),
    .cin(carry_temp),
    .sum(sum_temp[1]),
    .cout(cout)
);

assign sum[1:0] = sum_temp[1:0];

endmodule

module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule