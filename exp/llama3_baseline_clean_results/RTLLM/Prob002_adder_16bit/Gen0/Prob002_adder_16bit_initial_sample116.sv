// 1-bit full adder
module adder_1bit(
    input a,
    input b,
    input Cin,
    output Cout,
    output y
);
    assign y = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Cout
);
    wire [7:0] carry;
    assign carry[0] = Cin;
    adder_1bit adder0(
        .a(a[0]),
        .b(b[0]),
        .Cin(carry[0]),
        .Cout(carry[1]),
        .y(y[0])
    );
    adder_1bit adder1(
        .a(a[1]),
        .b(b[1]),
        .Cin(carry[1]),
        .Cout(carry[2]),
        .y(y[1])
    );
    adder_1bit adder2(
        .a(a[2]),
        .b(b[2]),
        .Cin(carry[2]),
        .Cout(carry[3]),
        .y(y[2])
    );
    adder_1bit adder3(
        .a(a[3]),
        .b(b[3]),
        .Cin(carry[3]),
        .Cout(carry[4]),
        .y(y[3])
    );
    adder_1bit adder4(
        .a(a[4]),
        .b(b[4]),
        .Cin(carry[4]),
        .Cout(carry[5]),
        .y(y[4])
    );
    adder_1bit adder5(
        .a(a[5]),
        .b(b[5]),
        .Cin(carry[5]),
        .Cout(carry[6]),
        .y(y[5])
    );
    adder_1bit adder6(
        .a(a[6]),
        .b(b[6]),
        .Cin(carry[6]),
        .Cout(carry[7]),
        .y(y[6])
    );
    adder_1bit adder7(
        .a(a[7]),
        .b(b[7]),
        .Cin(carry[7]),
        .Cout(Cout),
        .y(y[7])
    );
endmodule

// 16-bit full adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire Cout_lower;
    wire [7:0] y_lower, y_upper;
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .Cout(Cout_lower),
        .y(y_lower)
    );
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Cout_lower),
        .Cout(Co),
        .y(y_upper)
    );
    assign y[7:0] = y_lower;
    assign y[15:8] = y_upper;
endmodule