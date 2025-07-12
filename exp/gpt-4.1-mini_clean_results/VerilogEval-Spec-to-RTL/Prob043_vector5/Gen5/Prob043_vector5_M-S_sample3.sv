module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e}; // Concatenate inputs for easy indexing

    genvar idx;
    generate
        // There are 25 pairs (5x5). Index from 0 to 24:
        // For index idx: i = idx / 5, j = idx % 5
        for (idx = 0; idx < 25; idx = idx + 1) begin : gen_pairs
            wire [2:0] i = idx / 5; // division by constant 5 yields integer quotient
            wire [2:0] j = idx % 5; // modulus yields remainder
            // out bit mapping: out[24 - idx] corresponds to pair (i,j)
            assign out[24 - idx] = ~(inputs[i] ^ inputs[j]);
        end
    endgenerate

endmodule