module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Pack inputs into a 5-bit vector for easy indexing: a=bit4,...,e=bit0
    wire [4:0] in_vec = {a, b, c, d, e};

    genvar i, j;
    // Declare a 2D wire array to hold intermediate equality bits
    wire [4:0] row [4:0];  // row[i][j] = equality of in_vec[i] and in_vec[j]

    generate
        for (i = 0; i < 5; i = i +1) begin : ROWS
            for (j = 0; j < 5; j = j +1) begin : COLS
                assign row[i][j] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate

    // Flatten rows into output vector with correct bit ordering:
    // out[24] = ~(a^a) = row[4][4], out[23] = ~(a^b) = row[4][3], ..., out[0] = ~(e^e) = row[0][0]
    generate
        for (i = 0; i < 5; i = i +1) begin : FLATTEN_ROWS
            for (j = 0; j < 5; j = j +1) begin : FLATTEN_COLS
                // Calculate output bit index according to problem spec
                // MSB corresponds to row=4-i, col=4-j mapping to output bit 5*(4 - i) + (4 - j)
                assign out[5*(4 - i) + (4 - j)] = row[i][j];
            end
        end
    endgenerate

endmodule