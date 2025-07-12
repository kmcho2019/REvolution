module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] not_a;
    wire [2:0] not_b;
    wire [2:0] or_bits;
    wire       or_logical_intermediate [2:0];

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_ops
            assign not_a[i] = ~a[i];
            assign not_b[i] = ~b[i];
            assign or_bits[i] = a[i] | b[i];
            assign or_logical_intermediate[i] = a[i] | b[i];
        end
    endgenerate

    assign out_or_bitwise = or_bits;

    // Logical OR: reduction of or_bits (or equivalently OR of or_logical_intermediate bits)
    assign out_or_logical = or_logical_intermediate[0] | or_logical_intermediate[1] | or_logical_intermediate[2];

    // Concatenate inverted b (upper bits) and inverted a (lower bits) for out_not
    assign out_not = {not_b, not_a};

endmodule