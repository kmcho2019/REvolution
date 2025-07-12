// Module for a 1-bit full adder
module full_adder(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;

    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Module for an 8-bit full adder using 1-bit full adders
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] carry;

    full_adder fa0(a[0], b[0], Cin, y[0], carry[0]);
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(a[i], b[i], carry[i-1], y[i], carry[i]);
        end
    endgenerate
    assign Co = carry[7];
endmodule

// Module for a 16-bit full adder using 8-bit adders
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire carry8;

    adder_8bit adder_lo(a[7:0], b[7:0], Cin, y[7:0], carry8);
    adder_8bit adder_hi(a[15:8], b[15:8], carry8, y[15:8], Co);
endmodule