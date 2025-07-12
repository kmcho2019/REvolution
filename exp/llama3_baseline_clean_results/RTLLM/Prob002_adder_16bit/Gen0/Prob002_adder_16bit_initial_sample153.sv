// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,     // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co       // Carry-out output
);

    // Internal signal to carry the result of the full adder
    wire [7:0] sum;
    wire [7:0] carry;

    // Calculate the sum for each bit position
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // For bits 1 through 7, use the same logic but propagate the carry
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // The final carry-out is the carry from the most significant bit
    assign Co = carry[7];
    // Assign the sum to the output
    assign y = sum;

endmodule

// Define the 16-bit full adder module using two instances of the 8-bit adder
module adder_16bit(
    input [15:0] a,  // 16-bit input operand A
    input [15:0] b,  // 16-bit input operand B
    input Cin,      // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co       // Carry-out output
);

    // Internal signals to connect the two 8-bit adders
    wire [7:0] lower_sum;
    wire upper_cin;
    wire [7:0] upper_sum;

    // Instantiate the first 8-bit adder for the lower 8 bits
    adder_8bit lower_adder(
        .a(a[7:0]),     // Lower 8 bits of A
        .b(b[7:0]),     // Lower 8 bits of B
        .Cin(Cin),      // Carry-in
        .y(lower_sum), // Sum of lower 8 bits
        .Co(upper_cin) // Carry-out to upper adder
    );

    // Instantiate the second 8-bit adder for the upper 8 bits
    adder_8bit upper_adder(
        .a(a[15:8]),   // Upper 8 bits of A
        .b(b[15:8]),   // Upper 8 bits of B
        .Cin(upper_cin), // Carry-in from lower adder
        .y(upper_sum), // Sum of upper 8 bits
        .Co(Co)        // Final carry-out
    );

    // Combine the sums from the two adders to form the final 16-bit sum
    assign y = {upper_sum, lower_sum};

endmodule