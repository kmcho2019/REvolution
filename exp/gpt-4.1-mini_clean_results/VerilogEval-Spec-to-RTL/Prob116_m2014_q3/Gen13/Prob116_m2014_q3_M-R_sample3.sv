module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output      f
);

    // Name input bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray code to binary conversion for row bits (x3,x4)
    wire row_gray1 = x3;
    wire row_gray0 = x4;
    wire row_bin1  = row_gray1;
    wire row_bin0  = row_gray1 ^ row_gray0;

    // Gray code to binary conversion for column bits (x1,x2)
    wire col_gray1 = x1;
    wire col_gray0 = x2;
    wire col_bin1  = col_gray1;
    wire col_bin0  = col_gray1 ^ col_gray0;

    // Form a flat 4-bit address: {row_bin1, row_bin0, col_bin1, col_bin0}
    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    // Combinational function for Karnaugh map values (don't-cares as 0)
    function automatic logic kmap_func(input [3:0] addr_in);
        case(addr_in)
            4'b0000: kmap_func = 1'b0; // d->0
            4'b0001: kmap_func = 1'b0;
            4'b0010: kmap_func = 1'b0; // d->0
            4'b0011: kmap_func = 1'b0;

            4'b0100: kmap_func = 1'b0;
            4'b0101: kmap_func = 1'b0; // d->0
            4'b0110: kmap_func = 1'b1;
            4'b0111: kmap_func = 1'b0;

            4'b1000: kmap_func = 1'b1;
            4'b1001: kmap_func = 1'b1;
            4'b1010: kmap_func = 1'b0;
            4'b1011: kmap_func = 1'b0; // d->0

            4'b1100: kmap_func = 1'b1;
            4'b1101: kmap_func = 1'b1;
            4'b1110: kmap_func = 1'b0; // d->0
            4'b1111: kmap_func = 1'b0; // d->0

            default: kmap_func = 1'b0;
        endcase
    endfunction

    // Continuous assignment for output f
    assign f = kmap_func(addr);

endmodule