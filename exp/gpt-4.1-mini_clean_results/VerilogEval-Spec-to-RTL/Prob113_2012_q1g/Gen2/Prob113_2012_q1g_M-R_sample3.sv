module TopModule (
    input  [3:0] x,
    output      f
);

    // The Karnaugh map indexing:
    // Rows: x[2] x[3]
    // Columns: x[0] x[1]
    // Thus, address for lookup = {x[2], x[3], x[0], x[1]}

    // Construct the 16-bit ROM lookup with addresses from 0 to 15 as {x[2], x[3], x[0], x[1]}:
    // We enumerate all combinations and assign the output from the given K-map:

    // K-map:
    //             x[0]x[1]
    // x[2]x[3]  00  01  11  10
    //  00     | 1 | 0 | 0 | 1 |
    //  01     | 0 | 0 | 0 | 0 |
    //  11     | 1 | 1 | 1 | 0 |
    //  10     | 1 | 1 | 0 | 1 |

    // Addresses and their f values:
    // addr= {x[2],x[3],x[0],x[1]}  value
    // 0  = 0 0 0 0 -> row=00 col=00 -> 1
    // 1  = 0 0 0 1 -> row=00 col=01 -> 0
    // 2  = 0 0 1 0 -> row=00 col=10 -> 1
    // 3  = 0 0 1 1 -> row=00 col=11 -> 0
    // 4  = 0 1 0 0 -> row=01 col=00 -> 0
    // 5  = 0 1 0 1 -> row=01 col=01 -> 0
    // 6  = 0 1 1 0 -> row=01 col=10 -> 0
    // 7  = 0 1 1 1 -> row=01 col=11 -> 0
    // 8  = 1 0 0 0 -> row=10 col=00 -> 1
    // 9  = 1 0 0 1 -> row=10 col=01 -> 1
    // 10 = 1 0 1 0 -> row=10 col=10 -> 1
    // 11 = 1 0 1 1 -> row=10 col=11 -> 0
    // 12 = 1 1 0 0 -> row=11 col=00 -> 1
    // 13 = 1 1 0 1 -> row=11 col=01 -> 1
    // 14 = 1 1 1 0 -> row=11 col=10 -> 0
    // 15 = 1 1 1 1 -> row=11 col=11 -> 1

    // Arrange bits from bit0 (addr0) to bit15 (addr15):
    // bit15 .. bit0 = 16'b 1 0 1 1 1 0 0 0 0 0 1 0 1 0 0 1 (reversing accordingly)
    // From above:
    // addr: val
    //  0 :1
    //  1 :0
    //  2 :1
    //  3 :0
    //  4 :0
    //  5 :0
    //  6 :0
    //  7 :0
    //  8 :1
    //  9 :1
    // 10 :1
    // 11 :0
    // 12 :1
    // 13 :1
    // 14 :0
    // 15 :1

    localparam [15:0] ROM = 16'b1011010001110001;

    wire [3:0] addr = {x[2], x[3], x[0], x[1]};
    assign f = ROM[addr];

endmodule