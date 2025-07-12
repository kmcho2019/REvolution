module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output reg      f
);

    // Name input bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray to binary decoding for row (x3, x4)
    // binary_row[1] = x3 (MSB)
    // binary_row[0] = x3 ^ x4 (LSB)
    wire row_bin1 = x3;
    wire row_bin0 = x3 ^ x4;

    // Gray to binary decoding for column (x1, x2)
    // binary_col[1] = x1 (MSB)
    // binary_col[0] = x1 ^ x2 (LSB)
    wire col_bin1 = x1;
    wire col_bin0 = x1 ^ x2;

    // Concatenate to form a 4-bit address: {row_bin[1:0], col_bin[1:0]}
    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    always @(*) begin
        case(addr)
            // From K-map after Gray-to-binary decoding, don't cares set to 0

            4'b0000: f = 1'b0; // row=00 col=00 (d->0)
            4'b0001: f = 1'b0; // row=00 col=01 (0)
            4'b0010: f = 1'b0; // row=00 col=10 (d->0)
            4'b0011: f = 1'b0; // row=00 col=11 (d->0)

            4'b0100: f = 1'b0; // row=01 col=00 (0)
            4'b0101: f = 1'b0; // row=01 col=01 (d->0)
            4'b0110: f = 1'b1; // row=01 col=10 (1)
            4'b0111: f = 1'b0; // row=01 col=11 (0)

            4'b1000: f = 1'b1; // row=10 col=00 (1)
            4'b1001: f = 1'b1; // row=10 col=01 (1)
            4'b1010: f = 1'b0; // row=10 col=10 (0)
            4'b1011: f = 1'b0; // row=10 col=11 (d->0)

            4'b1100: f = 1'b1; // row=11 col=00 (1)
            4'b1101: f = 1'b1; // row=11 col=01 (1)
            4'b1110: f = 1'b0; // row=11 col=10 (d->0)
            4'b1111: f = 1'b0; // row=11 col=11 (d->0)

            default: f = 1'b0; // Safety fallback
        endcase
    end

endmodule