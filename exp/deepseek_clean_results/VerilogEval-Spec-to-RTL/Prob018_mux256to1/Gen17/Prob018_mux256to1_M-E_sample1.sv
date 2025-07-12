module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    wire [255:0] sel_match;
    wire [255:0] masked_bits;

    // Generate 256 parallel comparators
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : gen_compare
            assign sel_match[i] = (sel == i);
            assign masked_bits[i] = in[i] & sel_match[i];
        end
    endgenerate

    // OR-reduce all masked bits
    assign out = |masked_bits;

endmodule