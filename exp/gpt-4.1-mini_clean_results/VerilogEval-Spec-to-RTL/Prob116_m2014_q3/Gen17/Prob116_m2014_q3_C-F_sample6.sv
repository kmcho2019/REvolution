module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    // Explicitly name input bits for clarity (mapping problem x[i] to x[i-1])
    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // Gray-to-binary decoding for row bits (x3, x4)
    wire row_bin1 = x3;
    wire row_bin0 = x3 ^ x4;

    // Gray-to-binary decoding for column bits (x1, x2)
    wire col_bin1 = x1;
    wire col_bin0 = x1 ^ x2;

    // Form the 4-bit decoded address
    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    // Function encapsulating Karnaugh map lookup with don't-cares = 0
    function automatic logic kmap_f(input [3:0] a);
        case (a)
            // row=00 (0), col=00..11
            4'b0000: kmap_f = 1'b0; // d -> 0
            4'b0001: kmap_f = 1'b0;
            4'b0010: kmap_f = 1'b0; // d -> 0
            4'b0011: kmap_f = 1'b0; // d -> 0

            // row=01 (1), col=00..11
            4'b0100: kmap_f = 1'b0;
            4'b0101: kmap_f = 1'b0; // d -> 0
            4'b0110: kmap_f = 1'b1;
            4'b0111: kmap_f = 1'b0;

            // row=10 (2), col=00..11
            4'b1000: kmap_f = 1'b1;
            4'b1001: kmap_f = 1'b1;
            4'b1010: kmap_f = 1'b0;
            4'b1011: kmap_f = 1'b0; // d -> 0

            // row=11 (3), col=00..11
            4'b1100: kmap_f = 1'b1;
            4'b1101: kmap_f = 1'b1;
            4'b1110: kmap_f = 1'b0; // d -> 0
            4'b1111: kmap_f = 1'b0; // d -> 0

            default: kmap_f = 1'b0;
        endcase
    endfunction

    // Assign output f from function result
    assign f = kmap_f(addr);

endmodule