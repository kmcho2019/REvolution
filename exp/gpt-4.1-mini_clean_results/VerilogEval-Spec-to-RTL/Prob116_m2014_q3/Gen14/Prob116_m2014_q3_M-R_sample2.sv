module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    // Gray-to-binary decode function and lookup combined
    function automatic logic func_kmap(input [3:0] addr);
        begin
            // Map from K-map after Gray-to-binary decoding (don't-care treated as 0)
            case(addr)
                4'b0000: func_kmap = 1'b0; // row=00 col=00 (d->0)
                4'b0001: func_kmap = 1'b0; // row=00 col=01 (0)
                4'b0010: func_kmap = 1'b0; // row=00 col=10 (d->0)
                4'b0011: func_kmap = 1'b0; // row=00 col=11 (d->0)

                4'b0100: func_kmap = 1'b0; // row=01 col=00 (0)
                4'b0101: func_kmap = 1'b0; // row=01 col=01 (d->0)
                4'b0110: func_kmap = 1'b1; // row=01 col=10 (1)
                4'b0111: func_kmap = 1'b0; // row=01 col=11 (0)

                4'b1000: func_kmap = 1'b1; // row=10 col=00 (1)
                4'b1001: func_kmap = 1'b1; // row=10 col=01 (1)
                4'b1010: func_kmap = 1'b0; // row=10 col=10 (0)
                4'b1011: func_kmap = 1'b0; // row=10 col=11 (d->0)

                4'b1100: func_kmap = 1'b1; // row=11 col=00 (1)
                4'b1101: func_kmap = 1'b1; // row=11 col=01 (1)
                4'b1110: func_kmap = 1'b0; // row=11 col=10 (d->0)
                4'b1111: func_kmap = 1'b0; // row=11 col=11 (d->0)

                default: func_kmap = 1'b0;
            endcase
        end
    endfunction

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray code to binary conversion for row bits (x3,x4)
    wire row_bin1 = x3;
    wire row_bin0 = x3 ^ x4;

    // Gray code to binary conversion for column bits (x1,x2)
    wire col_bin1 = x1;
    wire col_bin0 = x1 ^ x2;

    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    assign f = func_kmap(addr);

endmodule