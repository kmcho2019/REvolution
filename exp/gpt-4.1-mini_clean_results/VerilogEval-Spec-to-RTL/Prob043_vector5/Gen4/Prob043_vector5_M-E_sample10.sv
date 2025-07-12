module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Store inputs in array for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};

    // Precompute all pair indices in a single-dimensional array (25 pairs)
    // The pairs are enumerated as (row,col) = (i,j) with i,j from 0 to 4:
    // out[24 - idx] = ~(inputs[i] ^ inputs[j]) where idx = i*5 + j
    // So out[24] = ~(a ^ a) (i=0,j=0), out[23] = ~(a ^ b) (i=0,j=1), etc.

    genvar idx;
    generate
        for (idx = 0; idx < 25; idx = idx + 1) begin: pairwise
            // Extract row and col indices
            localparam int i = idx / 5;
            localparam int j = idx % 5;
            // Assign output bit starting from MSB down to LSB
            assign out[24 - idx] = ~(inputs[i] ^ inputs[j]);
        end
    endgenerate
endmodule