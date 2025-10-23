module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Create an array of inputs for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};

    // Generate all pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Map 2D matrix indices to 1D output vector
                // out[24:0] corresponds to (0,0) to (4,4) in row-major order
                assign out[(4-i)*5 + (4-j)] = (i == j) ? 1'b1 : ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule