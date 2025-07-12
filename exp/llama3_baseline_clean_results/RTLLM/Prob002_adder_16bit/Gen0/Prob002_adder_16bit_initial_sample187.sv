// Define a module for an 8-bit full adder
module adder_8bit(
    input  [7:0] a,    // 8-bit input operand A
    input  [7:0] b,    // 8-bit input operand B
    input        Cin,  // Carry-in input
    output [7:0] y,    // 8-bit output representing the sum of A and B
    output       Co     // Carry-out output
);

    // Initialize an internal wire to hold the carry from each bit addition
    wire [7:0] carry;

    // Perform bit-by-bit addition and calculate carry for each bit
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // For each of the remaining bits (1 to 7), perform addition and calculate carry
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // The carry-out of the 8-bit adder is the carry from the most significant bit
    assign Co = carry[7];

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input  [15:0] a,   // 16-bit input operand A
    input  [15:0] b,   // 16-bit input operand B
    input         Cin,  // Carry-in input
    output [15:0] y,   // 16-bit output representing the sum of A and B
    output        Co    // Carry-out output
);

    // Instantiate two 8-bit adders
    wire [7:0] sum_lower;
    wire       carry_middle;

    adder_8bit u_adder_lower(
        .a(a[7:0]),     // Lower 8 bits of A
        .b(b[7:0]),     // Lower 8 bits of B
        .Cin(Cin),      // Carry-in
        .y(sum_lower),  // Sum of lower 8 bits
        .Co(carry_middle) // Carry from lower 8 bits to upper 8 bits
    );

    wire [7:0] sum_upper;
    adder_8bit u_adder_upper(
        .a(a[15:8]),    // Upper 8 bits of A
        .b(b[15:8]),    // Upper 8 bits of B
        .Cin(carry_middle), // Carry from lower 8 bits
        .y(sum_upper),  // Sum of upper 8 bits
        .Co(Co)         // Carry-out of the 16-bit adder
    );

    // Combine the sums from the two 8-bit adders
    assign y = {sum_upper, sum_lower};

endmodule