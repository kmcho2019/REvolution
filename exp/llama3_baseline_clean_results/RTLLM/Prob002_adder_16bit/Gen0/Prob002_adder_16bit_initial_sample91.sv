// 1-bit full adder module
module adder_1bit(
    input a, b, Cin,
    output reg sum, Co
);
    always @(*) begin
        sum = a ^ b ^ Cin;
        Co = (a & b) | (a & Cin) | (b & Cin);
    end
endmodule

// 8-bit full adder module
module adder_8bit(
    input [7:0] a, b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:0] carry;
    assign carry[0] = Cin;
    adder_1bit adder_1bit_0(.a(a[0]), .b(b[0]), .Cin(carry[0]), .sum(y[0]), .Co(carry[1]));
    adder_1bit adder_1bit_1(.a(a[1]), .b(b[1]), .Cin(carry[1]), .sum(y[1]), .Co(carry[2]));
    adder_1bit adder_1bit_2(.a(a[2]), .b(b[2]), .Cin(carry[2]), .sum(y[2]), .Co(carry[3]));
    adder_1bit adder_1bit_3(.a(a[3]), .b(b[3]), .Cin(carry[3]), .sum(y[3]), .Co(carry[4]));
    adder_1bit adder_1bit_4(.a(a[4]), .b(b[4]), .Cin(carry[4]), .sum(y[4]), .Co(carry[5]));
    adder_1bit adder_1bit_5(.a(a[5]), .b(b[5]), .Cin(carry[5]), .sum(y[5]), .Co(carry[6]));
    adder_1bit adder_1bit_6(.a(a[6]), .b(b[6]), .Cin(carry[6]), .sum(y[6]), .Co(carry[7]));
    adder_1bit adder_1bit_7(.a(a[7]), .b(b[7]), .Cin(carry[7]), .sum(y[7]), .Co(Co));
endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a, b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire Co_8bit;
    adder_8bit adder_8bit_0(.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(y[7:0]), .Co(Co_8bit));
    adder_8bit adder_8bit_1(.a(a[15:8]), .b(b[15:8]), .Cin(Co_8bit), .y(y[15:8]), .Co(Co));
endmodule