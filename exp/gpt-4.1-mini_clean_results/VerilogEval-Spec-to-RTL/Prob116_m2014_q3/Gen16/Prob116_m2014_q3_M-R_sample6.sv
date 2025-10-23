module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    // Name input bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray code to binary conversion for row bits (x3, x4)
    wire row_bin1 = x3;
    wire row_bin0 = x3 ^ x4;

    // Gray code to binary conversion for column bits (x1, x2)
    wire col_bin1 = x1;
    wire col_bin0 = x1 ^ x2;

    // 4-bit address from decoded row and column
    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    // Use a function to return f based on addr
    function logic lookup_kmap(input [3:0] a);
        begin
            case(a)
                4'b0000: lookup_kmap = 1'b0; // d->0
                4'b0001: lookup_kmap = 1'b0;
                4'b0010: lookup_kmap = 1'b0; // d->0
                4'b0011: lookup_kmap = 1'b0;

                4'b0100: lookup_kmap = 1'b0;
                4'b0101: lookup_kmap = 1'b0; // d->0
                4'b0110: lookup_kmap = 1'b1;
                4'b0111: lookup_kmap = 1'b0;

                4'b1000: lookup_kmap = 1'b1;
                4'b1001: lookup_kmap = 1'b1;
                4'b1010: lookup_kmap = 1'b0;
                4'b1011: lookup_kmap = 1'b0; // d->0

                4'b1100: lookup_kmap = 1'b1;
                4'b1101: lookup_kmap = 1'b1;
                4'b1110: lookup_kmap = 1'b0; // d->0
                4'b1111: lookup_kmap = 1'b0; // d->0

                default: lookup_kmap = 1'b0;
            endcase
        end
    endfunction

    assign f = lookup_kmap(addr);

endmodule