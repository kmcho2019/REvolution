module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Create a vector of all inputs
    wire [4:0] inputs = {e, d, c, b, a};
    
    // Generate all pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                assign out[i*5 + j] = (i == j) ? 1'b1 : inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

endmodule