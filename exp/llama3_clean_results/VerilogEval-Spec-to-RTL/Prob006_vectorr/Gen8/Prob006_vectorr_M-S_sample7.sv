module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, you can use a more concise syntax:
    // assign out = in[7:0];

    // However, to achieve the bit reversal, the following syntax can be used:
    assign out = in[7:0];

    // The above syntax doesn't reverse the bits, the correct syntax would be:
    assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

endmodule