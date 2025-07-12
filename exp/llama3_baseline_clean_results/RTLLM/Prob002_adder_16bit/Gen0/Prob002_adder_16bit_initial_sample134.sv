// Define the 8-bit full adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] y_int;
    wire [7:0] carry_int;

    assign y_int[0] = a[0] ^ b[0] ^ Cin;
    assign carry_int[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y_int[i] = a[i] ^ b[i] ^ carry_int[i-1];
            assign carry_int[i] = (a[i] & b[i]) | (a[i] & carry_int[i-1]) | (b[i] & carry_int[i-1]);
        end
    endgenerate

    assign y = y_int;
    assign Co = carry_int[7];
endmodule

// Define the 16-bit full adder module using the 8-bit adder
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;

    wire C_mid;

    // First 8-bit adder for lower bits
    adder_8bit u1(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C_mid)
    );

    // Second 8-bit adder for upper bits
    adder_8bit u2(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule