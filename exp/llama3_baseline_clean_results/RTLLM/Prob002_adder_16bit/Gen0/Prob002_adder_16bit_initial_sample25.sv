// Define a 1-bit full adder
module full_adder_1bit(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;

    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define an 8-bit full adder using the 1-bit full adder
module full_adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] carry;

    full_adder_1bit fa0(a[0], b[0], Cin, y[0], carry[0]);
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder_1bit fa(a[i], b[i], carry[i-1], y[i], carry[i]);
        end
    endgenerate
    assign Co = carry[7];
endmodule

// Define the 16-bit full adder
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire carry;

    full_adder_8bit fa_low(a[7:0], b[7:0], Cin, y[7:0], carry);
    full_adder_8bit fa_high(a[15:8], b[15:8], carry, y[15:8], Co);
endmodule