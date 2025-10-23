module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Create an array of inputs for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate all pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Calculate output index: (4-i)*5 + (4-j) for descending order
                localparam idx = (4-i)*5 + (4-j);
                // Self-comparison optimization
                assign out[idx] = (i == j) ? 1'b1 : inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

endmodule