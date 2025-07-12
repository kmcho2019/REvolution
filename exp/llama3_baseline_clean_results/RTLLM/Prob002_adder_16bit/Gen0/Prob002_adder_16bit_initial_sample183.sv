// Define a 1-bit full adder module
module full_adder_1bit(
    input a,
    input b,
    input Cin,
    output reg sum,
    output reg Cout
);
    always @(*) begin
        {Cout, sum} = a + b + Cin;
    end
endmodule

// Define an 8-bit full adder module using the 1-bit full adder
module full_adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output reg [7:0] sum,
    output reg Cout
);
    wire [7:0] carry;
    assign carry[0] = Cin;
    full_adder_1bit fa0(a[0], b[0], carry[0], sum[0], carry[1]);
    full_adder_1bit fa1(a[1], b[1], carry[1], sum[1], carry[2]);
    full_adder_1bit fa2(a[2], b[2], carry[2], sum[2], carry[3]);
    full_adder_1bit fa3(a[3], b[3], carry[3], sum[3], carry[4]);
    full_adder_1bit fa4(a[4], b[4], carry[4], sum[4], carry[5]);
    full_adder_1bit fa5(a[5], b[5], carry[5], sum[5], carry[6]);
    full_adder_1bit fa6(a[6], b[6], carry[6], sum[6], carry[7]);
    full_adder_1bit fa7(a[7], b[7], carry[7], sum[7], Cout);
endmodule

// Define the 16-bit full adder module using the 8-bit full adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output reg [15:0] y,
    output reg Co
);
    wire c8;
    full_adder_8bit fa_low(a[7:0], b[7:0], Cin, y[7:0], c8);
    full_adder_8bit fa_high(a[15:8], b[15:8], c8, y[15:8], Co);
endmodule