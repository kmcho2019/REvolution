// Full adder cell
module full_adder(a, b, Cin, S, Co);
    input a, b, Cin;
    output S, Co;

    wire Sum, Carry;

    assign Sum = a ^ b ^ Cin;
    assign Carry = (a & b) | (a & Cin) | (b & Cin);

    assign S = Sum;
    assign Co = Carry;
endmodule

// 8-bit full adder
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] Sum;
    wire [7:1] Carry;

    full_adder fa0 (.a(a[0]), .b(b[0]), .Cin(Cin), .S(y[0]), .Co(Carry[1]));
    full_adder fa1 (.a(a[1]), .b(b[1]), .Cin(Carry[1]), .S(y[1]), .Co(Carry[2]));
    full_adder fa2 (.a(a[2]), .b(b[2]), .Cin(Carry[2]), .S(y[2]), .Co(Carry[3]));
    full_adder fa3 (.a(a[3]), .b(b[3]), .Cin(Carry[3]), .S(y[3]), .Co(Carry[4]));
    full_adder fa4 (.a(a[4]), .b(b[4]), .Cin(Carry[4]), .S(y[4]), .Co(Carry[5]));
    full_adder fa5 (.a(a[5]), .b(b[5]), .Cin(Carry[5]), .S(y[5]), .Co(Carry[6]));
    full_adder fa6 (.a(a[6]), .b(b[6]), .Cin(Carry[6]), .S(y[6]), .Co(Carry[7]));
    full_adder fa7 (.a(a[7]), .b(b[7]), .Cin(Carry[7]), .S(y[7]), .Co(Co));

endmodule

// 16-bit full adder
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire Co_8bit;

    adder_8bit adder_low (.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(y[7:0]), .Co(Co_8bit));
    adder_8bit adder_high (.a(a[15:8]), .b(b[15:8]), .Cin(Co_8bit), .y(y[15:8]), .Co(Co));

endmodule