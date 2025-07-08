module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a,b,c,d,e};

    // We map pairs (i,j) where i,j in [0..4] to output bits [24:0],
    // out[24 - (5*i + j)] = (inputs[i] == inputs[j])
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer
            for (j = 0; j < 5; j = j + 1) begin : inner
                assign out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule