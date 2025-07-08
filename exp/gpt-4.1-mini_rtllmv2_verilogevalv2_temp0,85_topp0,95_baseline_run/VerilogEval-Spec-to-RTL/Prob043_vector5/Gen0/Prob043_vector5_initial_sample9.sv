module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    genvar i, j;

    // Create a 5x5 matrix of pairwise XNOR of inputs[i] and inputs[j]
    // Map to out[24] down to out[0] in row-major order
    generate
        for(i = 0; i < 5; i = i + 1) begin : row
            for(j = 0; j < 5; j = j + 1) begin : col
                // Calculate output bit index: 24 - (5*i + j)
                // out[24] corresponds to inputs[0] vs inputs[0]
                // out[0] corresponds to inputs[4] vs inputs[4]
                assign out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]); // XNOR
            end
        end
    endgenerate
endmodule