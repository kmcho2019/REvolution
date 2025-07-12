module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Create a vector of all inputs for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};

    // Generate all pairwise comparisons using nested loops
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Calculate output index: (4-i)*5 + (4-j)
                // This gives us the same ordering as the original specification
                assign out[(4-i)*5 + (4-j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule