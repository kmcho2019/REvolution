module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Bundle inputs into an array
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate all pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer_loop
            for (j = 0; j < 5; j = j + 1) begin : inner_loop
                assign out[24 - (i*5 + j)] = (inputs[i] == inputs[j]);
            end
        end
    endgenerate

endmodule