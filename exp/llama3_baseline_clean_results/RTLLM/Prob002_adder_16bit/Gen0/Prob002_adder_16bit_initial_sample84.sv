// Define the 8-bit adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] sum;
    wire [7:0] carry;

    // Calculate sum and carry for each bit position
    full_adder fa0(a[0], b[0], Cin, sum[0], carry[0]);
    full_adder fa1(a[1], b[1], carry[0], sum[1], carry[1]);
    full_adder fa2(a[2], b[2], carry[1], sum[2], carry[2]);
    full_adder fa3(a[3], b[3], carry[2], sum[3], carry[3]);
    full_adder fa4(a[4], b[4], carry[3], sum[4], carry[4]);
    full_adder fa5(a[5], b[5], carry[4], sum[5], carry[5]);
    full_adder fa6(a[6], b[6], carry[5], sum[6], carry[6]);
    full_adder fa7(a[7], b[7], carry[6], sum[7], Co);

    // Assign the calculated sum to the output
    assign y = sum;

endmodule

// Define the full adder module used in the 8-bit adder
module full_adder(a, b, Cin, sum, Co);
    input a, b, Cin;
    output sum, Co;

    assign sum = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);

endmodule

// Define the 16-bit adder module
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;

    wire carry_8;

    // Instantiate two 8-bit adders
    adder_8bit adder_lower(a[7:0], b[7:0], Cin, y[7:0], carry_8);
    adder_8bit adder_upper(a[15:8], b[15:8], carry_8, y[15:8], Co);

endmodule