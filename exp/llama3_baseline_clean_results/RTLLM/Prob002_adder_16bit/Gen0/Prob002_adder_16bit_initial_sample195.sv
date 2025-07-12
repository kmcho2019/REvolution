module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] sum;
    wire Cout;

    full_adder fa0(a[0], b[0], Cin, sum[0], Cout);
    full_adder fa1(a[1], b[1], Cout, sum[1], Cout);
    full_adder fa2(a[2], b[2], Cout, sum[2], Cout);
    full_adder fa3(a[3], b[3], Cout, sum[3], Cout);
    full_adder fa4(a[4], b[4], Cout, sum[4], Cout);
    full_adder fa5(a[5], b[5], Cout, sum[5], Cout);
    full_adder fa6(a[6], b[6], Cout, sum[6], Cout);
    full_adder fa7(a[7], b[7], Cout, sum[7], Co);

    assign y = sum;
endmodule

module full_adder(a, b, Cin, sum, Cout);
    input a;
    input b;
    input Cin;
    output sum;
    output Cout;

    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;

    wire Cout_8bit;

    adder_8bit adder_lower(a[7:0], b[7:0], Cin, y[7:0], Cout_8bit);
    adder_8bit adder_upper(a[15:8], b[15:8], Cout_8bit, y[15:8], Co);
endmodule