module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Direct bitwise OR
    assign out_or_bitwise = a | b;

    // Logical OR reduction of the bitwise OR result
    assign out_or_logical = |(a | b);

    // Generate loop to assign out_not:
    // out_not[5:3] = ~b
    // out_not[2:0] = ~a
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : inv_bits
            assign out_not[i]     = ~a[i];
            assign out_not[i + 3] = ~b[i];
        end
    endgenerate

endmodule