module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Create an array of all inputs for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate all 25 pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer_loop
            for (j = 0; j < 5; j = j + 1) begin : inner_loop
                assign out[i*5 + j] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

endmodule