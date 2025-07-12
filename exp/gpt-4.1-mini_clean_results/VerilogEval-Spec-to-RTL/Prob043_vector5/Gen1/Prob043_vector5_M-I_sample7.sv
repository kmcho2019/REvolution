module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [0:4] inputs;  // inputs[0]=a ... inputs[4]=e
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer
            for (j = 0; j < 5; j = j + 1) begin : inner
                // out[24 - (i*5 + j)] = 1 if inputs[i] == inputs[j], else 0
                assign out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate
endmodule