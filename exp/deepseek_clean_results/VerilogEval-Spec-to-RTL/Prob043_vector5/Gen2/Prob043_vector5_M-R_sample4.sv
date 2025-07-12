module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Pack all inputs into an array for easier indexing
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate all 25 pairwise comparisons using nested loops
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer_loop
            for (j = 0; j < 5; j = j + 1) begin : inner_loop
                // Calculate output index: (4-i)*5 + (4-j)
                // This gives us the same ordering as the original solution
                assign out[(4-i)*5 + (4-j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule