// Module for an 8-bit full adder
module adder_8bit(
    a,      // Input operand A
    b,      // Input operand B
    Cin,    // Carry-in input
    y,      // Output sum
    Co      // Carry-out output
);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;
    wire [7:0] y_temp;
    wire Co_temp;

    // First bit addition (bit 0)
    full_adder fa0(a[0], b[0], Cin, y[0], Co_temp);

    // Remaining bits addition (bits 1 to 7)
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(a[i], b[i], Co_temp, y_temp[i-1], Co_temp);
            assign y[i] = y_temp[i-1];
        end
    endgenerate

    assign Co = Co_temp;
    assign y[7] = y_temp[6];

endmodule

// Module for a full adder (1-bit)
module full_adder(
    a,  // Input operand A
    b,  // Input operand B
    Cin, // Carry-in input
    y,  // Output sum
    Co  // Carry-out output
);
    input a;
    input b;
    input Cin;
    output y;
    output Co;
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);

endmodule

// Module for a 16-bit full adder
module adder_16bit(
    a,      // Input operand A
    b,      // Input operand B
    Cin,    // Carry-in input
    y,      // Output sum
    Co      // Carry-out output
);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;
    wire Co_temp;

    // Instantiate two 8-bit full adders
    adder_8bit adder_lower(
        .a(a[7:0]), 
        .b(b[7:0]), 
        .Cin(Cin), 
        .y(y[7:0]), 
        .Co(Co_temp)
    );

    adder_8bit adder_higher(
        .a(a[15:8]), 
        .b(b[15:8]), 
        .Cin(Co_temp), 
        .y(y[15:8]), 
        .Co(Co)
    );

endmodule