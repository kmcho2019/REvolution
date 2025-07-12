module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR - direct implementation
    assign out_or_bitwise[0] = a[0] | b[0];
    assign out_or_bitwise[1] = a[1] | b[1];
    assign out_or_bitwise[2] = a[2] | b[2];

    // Custom priority encoder for logical OR
    wire or_bit0 = a[0] | b[0];
    wire or_bit1 = a[1] | b[1];
    wire or_bit2 = a[2] | b[2];
    assign out_or_logical = or_bit2 | or_bit1 | or_bit0;

    // Distributed NOT operations with explicit bit ordering
    assign out_not[0] = ~a[0];  // a[0] inverse
    assign out_not[1] = ~a[1];  // a[1] inverse
    assign out_not[2] = ~a[2];  // a[2] inverse
    assign out_not[3] = ~b[0];  // b[0] inverse (upper half)
    assign out_not[4] = ~b[1];  // b[1] inverse
    assign out_not[5] = ~b[2];  // b[2] inverse
endmodule