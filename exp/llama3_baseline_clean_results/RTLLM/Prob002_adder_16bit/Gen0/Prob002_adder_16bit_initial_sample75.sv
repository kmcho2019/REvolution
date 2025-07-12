// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    wire [7:0] temp_y;
    wire [7:0] carry;

    // Full adder logic for each bit
    full_adder fa0(a[0], b[0], Cin, temp_y[0], carry[0]);
    full_adder fa1(a[1], b[1], carry[0], temp_y[1], carry[1]);
    full_adder fa2(a[2], b[2], carry[1], temp_y[2], carry[2]);
    full_adder fa3(a[3], b[3], carry[2], temp_y[3], carry[3]);
    full_adder fa4(a[4], b[4], carry[3], temp_y[4], carry[4]);
    full_adder fa5(a[5], b[5], carry[4], temp_y[5], carry[5]);
    full_adder fa6(a[6], b[6], carry[5], temp_y[6], carry[6]);
    full_adder fa7(a[7], b[7], carry[6], temp_y[7], carry[7]);

    // Assign the final carry-out
    assign Co = carry[7];
    
    // Assign the final output
    assign y = temp_y;

endmodule

// Define the full adder module for a single bit
module full_adder(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire [7:0] temp_y1;
    wire [7:0] temp_y2;
    wire Co1;

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit adder1(a[7:0], b[7:0], Cin, temp_y1, Co1);

    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit adder2(a[15:8], b[15:8], Co1, temp_y2, Co);

    // Assign the final output
    assign y[7:0] = temp_y1;
    assign y[15:8] = temp_y2;

endmodule