module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a, b, c, d, e};
    genvar i, j;

    // We'll map (i, j) to output index as:
    // out_index = 24 - (i*5 + j)
    // where i and j range from 0 to 4 representing inputs a..e.
    generate
        for (i = 0; i < 5; i = i + 1) begin: row_loop
            for (j = 0; j < 5; j = j + 1) begin: col_loop
                assign out[24 - (i*5 + j)] = in_vec[4 - i] ^~ in_vec[4 - j];
            end
        end
    endgenerate

endmodule