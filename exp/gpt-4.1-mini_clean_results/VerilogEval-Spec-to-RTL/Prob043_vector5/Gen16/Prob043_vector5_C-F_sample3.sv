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
        // i and j count from 0 to 4 (standard ascending order)
        // Mapping inputs indices as: 4 - i and 4 - j to match the required output bit order
        // Output bit index = 24 - (i*5 + j)
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                localparam int out_idx = 24 - (i*5 + j);
                assign out[out_idx] = inputs[4 - i] ~^ inputs[4 - j];
            end
        end
    endgenerate

endmodule