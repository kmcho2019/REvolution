module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};

    // Flattened 5x5 comparisons: out[24] compares a vs a, out[23] a vs b, ..., out[0] e vs e
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Calculate the output bit index based on problem statement: 
                // out[24] = compare a vs a (i=0,j=0)
                // So index = 24 - (5*i + j)
                assign out[24 - (5*i + j)] = ~(inputs[4 - i] ^ inputs[4 - j]);
            end
        end
    endgenerate
endmodule