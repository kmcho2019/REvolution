module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Store inputs in an array for straightforward indexing
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // The problem defines out[24] as comparison a vs a, which corresponds to (i=0, j=0)
                // Therefore, output bit index = 24 - (5*i + j)
                assign out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]); // XNOR operation
            end
        end
    endgenerate
endmodule