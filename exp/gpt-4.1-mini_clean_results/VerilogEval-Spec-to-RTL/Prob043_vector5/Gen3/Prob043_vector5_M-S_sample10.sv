module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1)
            for (j = 0; j < 5; j = j + 1)
                assign out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]);
    endgenerate
endmodule