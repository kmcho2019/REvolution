module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into vector inputs[4:0] = {a,b,c,d,e}
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        // Generate all 25 pairwise comparisons using nested loops
        // Bit index = 24 - (5*i + j), where i,j in [0..4]
        // inputs[4 - i] and inputs[4 - j] to map i,j=0..4 to inputs a..e respectively
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                assign out[24 - (5*i + j)] = inputs[4 - i] ~^ inputs[4 - j];
            end
        end
    endgenerate

endmodule