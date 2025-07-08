module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Create a 5-element vector of inputs for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer
            for (j = 0; j < 5; j = j + 1) begin : inner
                // Calculate bit index in out vector:
                // bit 24 corresponds to (i=0,j=0), bit 23 = (0,1), ..., bit 0 = (4,4)
                // So bit index = 24 - (i*5 + j)
                wire eq = ~(inputs[4 - i] ^ inputs[4 - j]);
                assign out[24 - (i*5 + j)] = eq;
            end
        end
    endgenerate

endmodule