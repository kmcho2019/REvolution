module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Store inputs in a temporary array for easy indexing
    wire [4:0] inputs = {e, d, c, b, a};
    
    // Generate all 25 pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                assign out[(4-i)*5 + (4-j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule