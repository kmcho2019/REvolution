// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co       // Carry-out output
);

    wire [7:0] y_temp; // Temporary wire for the sum
    wire [7:0] carry_temp; // Temporary wire for carries

    // Calculate the sum and carry for each bit position
    full_adder fa0(a[0], b[0], Cin, y_temp[0], carry_temp[0]);
    full_adder fa1(a[1], b[1], carry_temp[0], y_temp[1], carry_temp[1]);
    full_adder fa2(a[2], b[2], carry_temp[1], y_temp[2], carry_temp[2]);
    full_adder fa3(a[3], b[3], carry_temp[2], y_temp[3], carry_temp[3]);
    full_adder fa4(a[4], b[4], carry_temp[3], y_temp[4], carry_temp[4]);
    full_adder fa5(a[5], b[5], carry_temp[4], y_temp[5], carry_temp[5]);
    full_adder fa6(a[6], b[6], carry_temp[5], y_temp[6], carry_temp[6]);
    full_adder fa7(a[7], b[7], carry_temp[6], y_temp[7], carry_temp[7]);

    // Assign the calculated sum and carry-out
    assign y = y_temp;
    assign Co = carry_temp[7];

endmodule

// Define the module for a single bit full adder
module full_adder(
    input a,  // Single-bit input operand A
    input b,  // Single-bit input operand B
    input Cin, // Carry-in input
    output y, // Single-bit output representing the sum of A and B
    output Co  // Carry-out output
);

    // Calculate the sum and carry using basic logic operations
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);

endmodule

// Define the module for a 16-bit full adder
module adder_16bit(
    input [15:0] a, // 16-bit input operand A
    input [15:0] b, // 16-bit input operand B
    input Cin,      // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co       // Carry-out output
);

    wire Co_temp; // Temporary wire for the carry-out of the lower 8-bit adder

    // Instantiate two 8-bit adders for the lower and upper 8 bits
    adder_8bit lower_adder(a[7:0], b[7:0], Cin, y[7:0], Co_temp);
    adder_8bit upper_adder(a[15:8], b[15:8], Co_temp, y[15:8], Co);

endmodule