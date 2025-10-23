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
    // We'll assign bits starting from out[24] down to out[0] 
    // with out[25*i + j] equivalent to out[24 - (5*i + j)]
    wire [24:0] out_internal;

    generate
        for (i = 0; i < 5; i = i + 1) begin : i_loop
            for (j = 0; j < 5; j = j + 1) begin : j_loop
                // Calculate position in output vector
                // out index = 24 - (5*i + j)
                assign out_internal[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    assign out = out_internal;

endmodule