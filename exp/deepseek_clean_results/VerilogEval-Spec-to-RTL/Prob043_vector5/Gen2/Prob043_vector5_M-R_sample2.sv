module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Pack inputs into a vector for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};

    // Generate all pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                assign out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule