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
    wire [24:0] temp_out;

    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Calculate index as per problem: out[24 - (5*i + j)]
                assign temp_out[24 - (5*i + j)] = inputs[4 - i] ^~ inputs[4 - j]; // XNOR for equality
            end
        end
    endgenerate

    assign out = temp_out;
endmodule