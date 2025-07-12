module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for indexed access
    wire [4:0] inputs = {a, b, c, d, e};

    genvar row, col;
    generate
        for (row = 0; row < 5; row = row + 1) begin : gen_row
            for (col = 0; col < 5; col = col + 1) begin : gen_col
                // Calculate output bit index to match specified ordering:
                // out[24] = (0,0) = a vs a, ..., out[0] = (4,4) = e vs e
                localparam int bit_index = (4 - row)*5 + (4 - col);
                assign out[bit_index] = ~(inputs[row] ^ inputs[col]); // XNOR for equality
            end
        end
    endgenerate

endmodule