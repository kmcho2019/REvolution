module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into an array for indexed access
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    // We need to map (i,j) pairs to bit indices: out[(4 - i)*5 + (4 - j)]
    // since out[24] corresponds to (i=4,j=4), out[0] to (i=0,j=0)
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                localparam int bit_pos = (4 - i) * 5 + (4 - j);
                assign out[bit_pos] = ~(inputs[i] ^ inputs[j]); // XNOR
            end
        end
    endgenerate
endmodule