module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Pack inputs into a vector for easy indexed access
    wire [4:0] in_bits = {a, b, c, d, e}; // in_bits[4]=a, [3]=b, [2]=c, [1]=d, [0]=e

    genvar i, j;

    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Map out[24] = equality(a,a) = out[24 - (0*5+0)]
                // Thus out[24 - (i*5 + j)] corresponds to (in_bits[i], in_bits[j])
                assign out[24 - (i*5 + j)] = ~(in_bits[i] ^ in_bits[j]); // XNOR for equality
            end
        end
    endgenerate

endmodule