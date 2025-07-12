module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Pack inputs into a vector for easy indexed access
    // Index 0 = a (MSB), index 4 = e (LSB)
    wire [4:0] in_bits = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // out[24 - (i*5 + j)] maps:
                // (0,0) = (a,a) -> out[24]
                // (0,1) = (a,b) -> out[23]
                // ...
                // (4,4) = (e,e) -> out[0]
                assign out[24 - (i*5 + j)] = ~(in_bits[i] ^ in_bits[j]);
            end
        end
    endgenerate

endmodule