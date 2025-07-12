module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    wire [24:0] temp_out;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                assign temp_out[i*5 + j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    // Reverse bits to match original output mapping: out[k] = temp_out[24 - k]
    genvar k;
    generate
        for (k = 0; k < 25; k = k + 1) begin : gen_rev
            assign out[k] = temp_out[24 - k];
        end
    endgenerate
endmodule