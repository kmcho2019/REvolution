module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Bundle inputs into a vector for systematic processing
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate all pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                assign out[(4-i)*5 + (4-j)] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

    /* The mapping creates this pattern:
       out[24] = inputs[0]~^inputs[0] (a~^a)
       out[23] = inputs[0]~^inputs[1] (a~^b)
       ...
       out[0]  = inputs[4]~^inputs[4] (e~^e)
    */

endmodule