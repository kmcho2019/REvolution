module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
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

    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    // Function to implement Karnaugh map lookup
    function automatic logic lookup_f(input [3:0] addr);
        case(addr)
            4'b0000: lookup_f = 1'b0; // d->0
            4'b0001: lookup_f = 1'b0;
            4'b0010: lookup_f = 1'b0; // d->0
            4'b0011: lookup_f = 1'b0; // d->0

            4'b0100: lookup_f = 1'b0;
            4'b0101: lookup_f = 1'b0; // d->0
            4'b0110: lookup_f = 1'b1;
            4'b0111: lookup_f = 1'b0;

            4'b1000: lookup_f = 1'b1;
            4'b1001: lookup_f = 1'b1;
            4'b1010: lookup_f = 1'b0;
            4'b1011: lookup_f = 1'b0; // d->0

            4'b1100: lookup_f = 1'b1;
            4'b1101: lookup_f = 1'b1;
            4'b1110: lookup_f = 1'b0; // d->0
            4'b1111: lookup_f = 1'b0; // d->0

            default: lookup_f = 1'b0;
        endcase
    endfunction

    assign f = lookup_f(addr);

endmodule