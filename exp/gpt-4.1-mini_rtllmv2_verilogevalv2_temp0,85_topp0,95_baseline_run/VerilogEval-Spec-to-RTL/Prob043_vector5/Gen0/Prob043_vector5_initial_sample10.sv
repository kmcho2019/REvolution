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
        // We'll assign bits from out[24] down to out[0]
        // Index for out = 24 - (i*5 + j), where i and j in [0..4]
        for (i = 0; i < 5; i = i + 1) begin : loop_i
            for (j = 0; j < 5; j = j + 1) begin : loop_j
                assign out[24 - (i*5 + j)] = ~(inputs[4 - i] ^ inputs[4 - j]);
                // inputs[4 - i] because inputs vector is {a,b,c,d,e} = [4]=a ... [0]=e
            end
        end
    endgenerate

endmodule