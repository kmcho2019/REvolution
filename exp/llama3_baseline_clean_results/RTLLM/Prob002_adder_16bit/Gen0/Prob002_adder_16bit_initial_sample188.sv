// Define a module for a full adder
module full_adder(a, b, Cin, sum, Co);
    input a, b, Cin;
    output sum, Co;

    assign sum = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define a module for an 8-bit adder
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] carry;

    // First bit (LSB) of the adder
    full_adder fa0(a[0], b[0], Cin, y[0], carry[0]);

    // Middle bits of the adder
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(a[i], b[i], carry[i-1], y[i], carry[i]);
        end
    endgenerate

    // Assign the carry-out of the last full adder as the Co of the 8-bit adder
    assign Co = carry[7];
endmodule

// Define the module for a 16-bit adder
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire Co_8bit;

    // First 8-bit adder for the lower 8 bits
    adder_8bit adder_lower(a[7:0], b[7:0], Cin, y[7:0], Co_8bit);

    // Second 8-bit adder for the upper 8 bits
    adder_8bit adder_upper(a[15:8], b[15:8], Co_8bit, y[15:8], Co);
endmodule