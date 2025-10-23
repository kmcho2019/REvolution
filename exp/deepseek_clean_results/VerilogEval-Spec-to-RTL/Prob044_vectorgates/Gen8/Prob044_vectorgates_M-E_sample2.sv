module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Shared inversion logic
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;

    // Bit-sliced parallel processing
    assign out_or_bitwise[0] = a[0] | b[0];
    assign out_or_bitwise[1] = a[1] | b[1];
    assign out_or_bitwise[2] = a[2] | b[2];

    // Hierarchical logical OR with early termination
    wire or01 = out_or_bitwise[0] | out_or_bitwise[1];
    assign out_or_logical = or01 | out_or_bitwise[2];

    // Concatenated NOT outputs with shared inversion
    assign out_not = {not_b, not_a};

endmodule