// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co        // Carry-out output
);

    // Use a temporary variable to store the carry-out
    wire [7:0] carry;

    // Use a for loop to generate the full adder logic
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign Co = (a[7] ^ b[7]) & (a[7] ^ Cin) & (b[7] ^ Cin) | (a[7] & b[7]) | (a[7] & Cin) | (b[7] & Cin);

    // Generate the full adder logic for each bit position
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ (a[i-1] & b[i-1]) | (a[i-1] & Cin) | (b[i-1] & Cin);
        end
    endgenerate

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,  // 16-bit input operand A
    input [15:0] b,  // 16-bit input operand B
    input Cin,       // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co         // Carry-out output
);

    // Instantiate two 8-bit adder modules
    wire carry_mid;

    adder_8bit u_adder_lower(
       .a(a[7:0]),   // Lower 8 bits of input A
       .b(b[7:0]),   // Lower 8 bits of input B
       .Cin(Cin),    // Carry-in input
       .y(y[7:0]),   // Lower 8 bits of output Y
       .Co(carry_mid)// Carry-out from lower 8-bit adder
    );

    adder_8bit u_adder_upper(
       .a(a[15:8]),  // Upper 8 bits of input A
       .b(b[15:8]),  // Upper 8 bits of input B
       .Cin(carry_mid),// Carry-in from lower 8-bit adder
       .y(y[15:8]),  // Upper 8 bits of output Y
       .Co(Co)       // Carry-out from upper 8-bit adder
    );

endmodule