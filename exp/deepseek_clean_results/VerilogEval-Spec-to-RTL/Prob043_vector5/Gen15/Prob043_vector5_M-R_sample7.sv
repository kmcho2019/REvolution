module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Bundle inputs into a vector for easier indexing
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate all 25 pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer_loop
            for (j = 0; j < 5; j = j + 1) begin : inner_loop
                // Calculate the correct output index (24 downto 0)
                localparam idx = (4-i)*5 + (4-j);
                assign out[idx] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

endmodule