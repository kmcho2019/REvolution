// 8-bit full adder module
module adder_8bit(
    input  [7:0] a,  // 8-bit input operand A
    input  [7:0] b,  // 8-bit input operand B
    input        Cin,  // Carry-in input
    output [7:0] y,  // 8-bit output representing the sum of A and B
    output       Co  // Carry-out output
);

    // Internal signal to hold the carry-out from each bit addition
    wire [7:0] carry;

    // Generate the carry-out for each bit using a full adder for each bit
    assign carry[0] = a[0] & b[0] | a[0] & Cin | b[0] & Cin;
    assign y[0]     = a[0] ^ b[0] ^ Cin;

    // For bits 1 to 7, create a full adder for each bit
    // where the carry-in for each bit is the carry-out from the previous bit
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign carry[i] = a[i] & b[i] | a[i] & carry[i-1] | b[i] & carry[i-1];
            assign y[i]     = a[i] ^ b[i] ^ carry[i-1];
        end
    endgenerate

    // The carry-out of the 8-bit adder is the carry-out of the most significant bit
    assign Co = carry[7];

endmodule

// 16-bit full adder module
module adder_16bit(
    input  [15:0] a,  // 16-bit input operand A
    input  [15:0] b,  // 16-bit input operand B
    input         Cin,  // Carry-in input
    output [15:0] y,  // 16-bit output representing the sum of A and B
    output        Co  // Carry-out output
);

    // Internal signals to connect the two 8-bit adders
    wire [7:0] lower_sum;
    wire       lower_cout;
    wire [7:0] upper_sum;
    wire       upper_cout;

    // Instantiate the first 8-bit adder for the lower 8 bits
    adder_8bit u_lower_adder(
        .a     (a[7:0]),   // Lower 8 bits of input A
        .b     (b[7:0]),   // Lower 8 bits of input B
        .Cin   (Cin),     // Carry-in input
        .y     (lower_sum),  // Sum of lower 8 bits
        .Co    (lower_cout)  // Carry-out from lower 8 bits
    );

    // Instantiate the second 8-bit adder for the upper 8 bits
    adder_8bit u_upper_adder(
        .a     (a[15:8]),  // Upper 8 bits of input A
        .b     (b[15:8]),  // Upper 8 bits of input B
        .Cin   (lower_cout),  // Carry-in is the carry-out from the lower 8 bits
        .y     (upper_sum),   // Sum of upper 8 bits
        .Co    (upper_cout)   // Carry-out from the upper 8 bits (also the final carry-out)
    );

    // Combine the sums from the two 8-bit adders to form the final 16-bit sum
    assign y[7:0]   = lower_sum;
    assign y[15:8] = upper_sum;

    // The carry-out of the 16-bit adder is the carry-out from the upper 8-bit adder
    assign Co = upper_cout;

endmodule