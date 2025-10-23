module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] bit_idx,  // index of bit to output
    output       out
);

    wire selected_bit_a = a[bit_idx];
    wire selected_bit_b = b[bit_idx];

    assign out = sel ? selected_bit_b : selected_bit_a;

endmodule