// 1-bit full adder
module full_adder_1bit(a, b, Cin, sum, Co);
    input a, b, Cin;
    output sum, Co;

    assign sum = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit full adder
module full_adder_8bit(a, b, Cin, sum, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] sum;
    output Co;

    wire [7:0] carry;

    full_adder_1bit fa0(a[0], b[0], Cin, sum[0], carry[0]);
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder_1bit fa(a[i], b[i], carry[i-1], sum[i], carry[i]);
        end
    endgenerate
    assign Co = carry[7];
endmodule

// 16-bit full adder using two 8-bit adders
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire carry_8bit;

    full_adder_8bit fa_lower(a[7:0], b[7:0], Cin, y[7:0], carry_8bit);
    full_adder_8bit fa_upper(a[15:8], b[15:8], carry_8bit, y[15:8], Co);
endmodule