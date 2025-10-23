module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Direct implementation of K-map using nested ternary operators
// First level selects ab combination, second level selects cd combination
assign out = (~c & ~d) ? // cd = 00
                (~a & ~b) ? 1'b1 : // ab = 00
                (~a &  b) ? 1'b1 : // ab = 01
                ( a &  b) ? 1'b0 : // ab = 11
                            1'b1 : // ab = 10
             (~c &  d) ? // cd = 01
                (~a & ~b) ? 1'b1 : // ab = 00
                (~a &  b) ? 1'b0 : // ab = 01
                ( a &  b) ? 1'b0 : // ab = 11
                            1'b1 : // ab = 10
             ( c &  d) ? // cd = 11
                (~a & ~b) ? 1'b0 : // ab = 00
                (~a &  b) ? 1'b1 : // ab = 01
                ( a &  b) ? 1'b1 : // ab = 11
                            1'b1 : // ab = 10
             // cd = 10
                (~a & ~b) ? 1'b1 : // ab = 00
                (~a &  b) ? 1'b1 : // ab = 01
                ( a &  b) ? 1'b0 : // ab = 11
                            1'b0;  // ab = 10

endmodule