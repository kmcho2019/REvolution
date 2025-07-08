module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a,b,c,d,e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer
            for (j = 0; j < 5; j = j + 1) begin : inner
                // Calculate output bit index: 24 - (5*i + j)
                // out[24] = compare(a,a), out[23] = compare(a,b), ..., out[0] = compare(e,e)
                assign out[24 - (5*i + j)] = ~(inputs[4 - i] ^ inputs[4 - j]); // XNOR equals
            end
        end
    endgenerate

endmodule