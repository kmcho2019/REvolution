module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,     // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co      // Carry-out output
);

    wire [7:0] carry;
    assign carry[0] = Cin;
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign Co = (a[7] ^ b[7] ^ carry[7]) ? (a[7] & b[7]) | (b[7] & carry[7]) | (carry[7] & a[7]) : (a[7] & b[7]) | (a[7] & carry[7]) | (b[7] & carry[7]);

    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign carry[i] = (a[i-1] & b[i-1]) | (b[i-1] & carry[i-1]) | (carry[i-1] & a[i-1]);
            assign y[i] = a[i] ^ b[i] ^ carry[i];
        end
    endgenerate

endmodule

module adder_16bit(
    input [15:0] a,  // 16-bit input operand A
    input [15:0] b,  // 16-bit input operand B
    input Cin,      // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co       // Carry-out output
);

    wire Co_8bit;
    adder_8bit adder_lower(
        .a(a[7:0]),  // Lower 8 bits of A
        .b(b[7:0]),  // Lower 8 bits of B
        .Cin(Cin),  // Carry-in for the lower 8-bit adder
        .y(y[7:0]), // Lower 8 bits of the sum
        .Co(Co_8bit) // Carry-out from the lower 8-bit adder
    );

    adder_8bit adder_upper(
        .a(a[15:8]), // Upper 8 bits of A
        .b(b[15:8]), // Upper 8 bits of B
        .Cin(Co_8bit), // Carry-in for the upper 8-bit adder (from the lower 8-bit adder)
        .y(y[15:8]), // Upper 8 bits of the sum
        .Co(Co)      // Carry-out from the upper 8-bit adder
    );

endmodule