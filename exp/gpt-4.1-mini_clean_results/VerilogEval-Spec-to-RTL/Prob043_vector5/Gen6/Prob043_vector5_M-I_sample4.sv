module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};

    // Generate pairwise equality bits with XNOR operator
    genvar i, j;
    wire [24:0] temp_out;

    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Compute bit index: 24 - (5*i + j)
                // Use XNOR (~^) to check equality directly
                assign temp_out[24 - (5*i + j)] = inputs[4 - i] ~^ inputs[4 - j];
            end
        end
    endgenerate

    // Assign generated bits to output
    assign out = temp_out;

endmodule