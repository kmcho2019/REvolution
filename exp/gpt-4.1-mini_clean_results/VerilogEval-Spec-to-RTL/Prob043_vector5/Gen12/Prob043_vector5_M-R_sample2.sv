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
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Map output index as: out[24 - (i*5 + j)]
                // Because i=0,j=0 maps to out[24], ..., i=4,j=4 maps to out[0]
                assign out[24 - (i*5 + j)] = ~(inputs[4 - i] ^ inputs[4 - j]);
            end
        end
    endgenerate

endmodule