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
                // Map out bit index as 24 - (5*i + j) to match example
                assign out[24 - (5*i + j)] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate
endmodule