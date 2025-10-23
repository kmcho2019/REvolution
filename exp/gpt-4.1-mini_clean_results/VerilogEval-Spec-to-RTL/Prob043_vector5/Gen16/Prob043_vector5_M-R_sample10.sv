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

    // Declare a wire array to hold each bit before concatenation
    wire [24:0] out_bits;

    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                localparam idx = 24 - (5*i + j);
                assign out_bits[idx] = inputs[4 - i] ~^ inputs[4 - j];
            end
        end
    endgenerate

    assign out = out_bits;

endmodule