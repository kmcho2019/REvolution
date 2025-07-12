// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co       // Carry-out output
);

    // Use a temporary variable to hold the carry
    wire [7:0] temp;
    wire [7:0] sum;

    // Generate the sum and carry for each bit position
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign Co = (a[7] & b[7]) | (a[7] & sum[6]) | (b[7] & sum[6]);

    // For each bit position (except the least significant bit)
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ (a[i-1] & b[i-1]) | (a[i-1] & sum[i-1]) | (b[i-1] & sum[i-1]);
        end
    endgenerate

    // Assign the calculated sum to the output
    assign y = sum;

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a, // 16-bit input operand A
    input [15:0] b, // 16-bit input operand B
    input Cin,      // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co       // Carry-out output
);

    // Instantiate the 8-bit adder for the lower 8 bits
    wire [7:0] sum_lower;
    wire Cout_lower;

    adder_8bit u_adder_lower(
        .a(a[7:0]),  // Lower 8 bits of A
        .b(b[7:0]),  // Lower 8 bits of B
        .Cin(Cin),   // Carry-in
        .y(sum_lower), // Sum of lower 8 bits
        .Co(Cout_lower) // Carry-out from lower 8 bits
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    wire [7:0] sum_upper;
    wire Cout_upper;

    adder_8bit u_adder_upper(
        .a(a[15:8]), // Upper 8 bits of A
        .b(b[15:8]), // Upper 8 bits of B
        .Cin(Cout_lower), // Carry-in from lower 8 bits
        .y(sum_upper), // Sum of upper 8 bits
        .Co(Cout_upper) // Carry-out from upper 8 bits
    );

    // Assign the results to the output
    assign y[7:0] = sum_lower; // Lower 8 bits of the sum
    assign y[15:8] = sum_upper; // Upper 8 bits of the sum
    assign Co = Cout_upper; // Carry-out

endmodule