module cla_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout,
    output g,
    output p
);
    wire [3:0] gen = a & b;
    wire [3:0] prop = a ^ b;
    wire [4:0] carry;

    assign carry[0] = cin;
    assign carry[1] = gen[0] | (prop[0] & carry[0]);
    assign carry[2] = gen[1] | (prop[1] & gen[0]) | (prop[1] & prop[0] & carry[0]);
    assign carry[3] = gen[2] | (prop[2] & gen[1]) | (prop[2] & prop[1] & gen[0]) | 
                     (prop[2] & prop[1] & prop[0] & carry[0]);
    assign carry[4] = gen[3] | (prop[3] & gen[2]) | (prop[3] & prop[2] & gen[1]) | 
                     (prop[3] & prop[2] & prop[1] & gen[0]) | 
                     (prop[3] & prop[2] & prop[1] & prop[0] & carry[0]);

    assign sum = prop ^ carry[3:0];
    assign cout = carry[4];
    assign g = gen[3] | (prop[3] & gen[2]) | (prop[3] & prop[2] & gen[1]) | 
               (prop[3] & prop[2] & prop[1] & gen[0]);
    assign p = &prop;
endmodule

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire g0, p0, g1, p1;
    wire carry_mid;

    cla_4bit lower (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(),
        .g(g0),
        .p(p0)
    );

    cla_4bit upper (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_mid),
        .sum(sum[7:4]),
        .cout(cout),
        .g(g1),
        .p(p1)
    );

    assign carry_mid = g0 | (p0 & cin);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;

    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule