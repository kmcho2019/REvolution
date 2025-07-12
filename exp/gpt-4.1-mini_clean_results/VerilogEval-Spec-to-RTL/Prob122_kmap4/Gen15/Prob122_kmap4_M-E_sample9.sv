module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    // Concatenate inputs as address: abcd
    wire [3:0] addr = {a, b, c, d};

    // 16-bit LUT representing the K-map output for all 16 input combinations
    // Bit index corresponds to addr value.
    // According to the K-map, the pattern is:
    // addr:  0   1   2   3    4   5   6   7    8   9  10  11   12  13  14  15
    // value: 0   1   1   0    1   0   0   1    0   1   1   0    1   0   0   1
    //
    // However, we must be cautious about the order of bits and inputs mapping.
    // The original K-map is given with variables arranged in pairs:
    // cd (rows): 00, 01, 11, 10
    // ab (cols): 00, 01, 11, 10
    //
    // addr = {a, b, c, d} = abcd
    // To map the K-map order, we rearrange addr bits to cdab indexing:
    // cdab = {c, d, a, b}
    // We'll use cdab as index to get correct mapping.

    wire [3:0] cdab = {c, d, a, b};
    localparam [15:0] LUT = 16'b0101100101101001; // Encoded as per cdab indexing.

    always @(*) begin
        out = LUT[cdab];
    end

endmodule