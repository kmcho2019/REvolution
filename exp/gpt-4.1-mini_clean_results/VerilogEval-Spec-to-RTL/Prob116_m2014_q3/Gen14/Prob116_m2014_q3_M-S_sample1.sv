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
    wire row1 = x3;
    wire row0 = x3 ^ x4;

    // Gray code to binary conversion for column bits (x1,x2)
    wire col1 = x1;
    wire col0 = x1 ^ x2;

    // Implement minimized logic expression derived from K-map after decoding:
    // f = (row1 & ~row0)                    // row = 10 (binary 2)
    //     | (row1 & row0 & ~col1)          // row = 11 and col=0x
    //     | (~row1 & row0 & col1 & col0)  // row=01 col=11
    //     | (row1 & row0 & col1)           // row=11 col=01 or 11 (covers col1=1)
    // Note col1 high in row=11 covers a '1' in 4'b1101 and 4'b1001 (after decoding)
    //
    // Simplify carefully to cover all ones and ignore don't-cares (set them to 0).

    assign f = (row1 & ~row0)
             | (row1 & row0 & ~col1)
             | (~row1 & row0 & col1 & col0)
             | (row1 & row0 & col1);

endmodule