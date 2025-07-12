// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co        // Carry-out output
);

    // Internal wire to store the carry chain
    wire [7:0] carry;

    // Generate the full adder logic
    assign carry[0] = Cin;
    assign y[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);
    assign y[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);
    assign y[2] = a[2] ^ b[2] ^ carry[2];
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[3]);
    assign y[3] = a[3] ^ b[3] ^ carry[3];
    assign carry[4] = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);
    assign y[4] = a[4] ^ b[4] ^ carry[4];
    assign carry[5] = (a[4] & b[4]) | (a[4] & carry[4]) | (b[4] & carry[4]);
    assign y[5] = a[5] ^ b[5] ^ carry[5];
    assign carry[6] = (a[5] & b[5]) | (a[5] & carry[5]) | (b[5] & carry[5]);
    assign y[6] = a[6] ^ b[6] ^ carry[6];
    assign carry[7] = (a[6] & b[6]) | (a[6] & carry[6]) | (b[6] & carry[6]);
    assign y[7] = a[7] ^ b[7] ^ carry[7];
    assign Co = (a[7] & b[7]) | (a[7] & carry[7]) | (b[7] & carry[7]);

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,  // 16-bit input operand A
    input [15:0] b,  // 16-bit input operand B
    input Cin,       // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co         // Carry-out output
);

    // Internal wires to store the lower and upper 8-bit results
    wire [7:0] lower_y;
    wire [7:0] upper_y;

    // Internal wire to store the carry from the lower 8-bit adder
    wire lower_Co;

    // Instantiate two 8-bit adders
    adder_8bit lower_adder(
        .a(a[7:0]), 
        .b(b[7:0]), 
        .Cin(Cin), 
        .y(lower_y), 
        .Co(lower_Co)
    );

    adder_8bit upper_adder(
        .a(a[15:8]), 
        .b(b[15:8]), 
        .Cin(lower_Co), 
        .y(upper_y), 
        .Co(Co)
    );

    // Combine the results from the two 8-bit adders
    assign y[7:0] = lower_y;
    assign y[15:8] = upper_y;

endmodule