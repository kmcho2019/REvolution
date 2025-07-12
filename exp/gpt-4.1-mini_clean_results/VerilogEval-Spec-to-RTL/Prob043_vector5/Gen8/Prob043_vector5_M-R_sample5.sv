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
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Calculate index to match the output bit ordering
                localparam int idx = (4 - i)*5 + (4 - j);
                assign out[idx] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule