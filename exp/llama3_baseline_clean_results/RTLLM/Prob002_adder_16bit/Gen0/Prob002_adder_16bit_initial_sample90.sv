module adder_8bit(
    a,    // 8-bit input operand A
    b,    // 8-bit input operand B
    Cin,  // Carry-in input
    y,    // 8-bit output representing the sum of A and B
    Co    // Carry-out output
);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;
    wire [7:0] y_temp;

    assign y = a + b + Cin;
    assign Co = (a[7] & b[7]) | (a[7] & Cin) | (b[7] & Cin);

endmodule

module adder_16bit(
    a,    // 16-bit input operand A
    b,    // 16-bit input operand B
    Cin,  // Carry-in input
    y,    // 16-bit output representing the sum of A and B
    Co    // Carry-out output
);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;
    wire Co1;

    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co1)
    );

    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule