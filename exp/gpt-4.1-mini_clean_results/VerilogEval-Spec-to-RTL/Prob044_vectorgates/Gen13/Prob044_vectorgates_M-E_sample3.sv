module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [2:0] or_bits;
    assign or_bits = a | b;
    assign out_or_bitwise = or_bits;
    assign out_or_logical = |or_bits;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : invert_bits
            // Lower half (bits [2:0]): inverted a bits
            assign out_not[i]     = ~a[i];
            // Upper half (bits [5:3]): inverted b bits
            assign out_not[i+3] = ~b[i];
        end
    endgenerate

endmodule