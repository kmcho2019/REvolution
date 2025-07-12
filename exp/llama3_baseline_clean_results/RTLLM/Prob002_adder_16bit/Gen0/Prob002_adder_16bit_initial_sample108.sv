// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co        // Carry-out output
);

    // Initialize carry and sum variables
    wire [7:0] sum;
    wire [7:0] carry;

    // Generate sum and carry for each bit position
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // For each bit position from 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // Assign output
    assign y = sum;
    assign Co = carry[7];

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,  // 16-bit input operand A
    input [15:0] b,  // 16-bit input operand B
    input Cin,       // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co         // Carry-out output
);

    // Instantiate two 8-bit adders
    wire [7:0] sum_lower;
    wire Co_lower;
    wire [7:0] sum_upper;
    wire Co_upper;

    // Lower 8-bit adder (bits 7:0)
    adder_8bit u_lower(
        .a(a[7:0]),  // Input A (lower 8 bits)
        .b(b[7:0]),  // Input B (lower 8 bits)
        .Cin(Cin),   // Carry-in input
        .y(sum_lower), // Output sum (lower 8 bits)
        .Co(Co_lower)  // Carry-out from lower adder
    );

    // Upper 8-bit adder (bits 15:8)
    adder_8bit u_upper(
        .a(a[15:8]), // Input A (upper 8 bits)
        .b(b[15:8]), // Input B (upper 8 bits)
        .Cin(Co_lower), // Carry-in from lower adder
        .y(sum_upper),  // Output sum (upper 8 bits)
        .Co(Co_upper)   // Carry-out from upper adder
    );

    // Assign output
    assign y = {sum_upper, sum_lower}; // Combine upper and lower sums
    assign Co = Co_upper;               // Carry-out from upper adder

endmodule