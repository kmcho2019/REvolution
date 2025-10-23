module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR - computed per bit
    assign out_or_bitwise[0] = a[0] | b[0];
    assign out_or_bitwise[1] = a[1] | b[1];
    assign out_or_bitwise[2] = a[2] | b[2];

    // Logical OR - computed as reduction of bitwise OR
    wire [2:0] or_results;
    assign or_results = out_or_bitwise;
    assign out_or_logical = |or_results;

    // NOT operations with concatenation
    assign out_not[5:3] = ~b;  // Upper bits: NOT of b
    assign out_not[2:0] = ~a;   // Lower bits: NOT of a
endmodule