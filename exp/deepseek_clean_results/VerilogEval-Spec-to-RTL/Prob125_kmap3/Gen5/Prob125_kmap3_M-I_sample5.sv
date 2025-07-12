module TopModule (
    input a,
    input b,
    input c,
    input d,  // d remains unused
    output out
);
    wire [1:0] cd = {c, d};
    wire [1:0] ab = {a, b};
    
    assign out = (cd == 2'b00) ? (ab == 2'b00) ? 1'b0 :  // cd=00 cases
                                (ab == 2'b01) ? 1'b0 :
                                (ab == 2'b10) ? 1'b1 :
                                                1'b1 :
                 (cd == 2'b01) ? (ab == 2'b00) ? 1'b0 :  // cd=01 cases
                                (ab == 2'b01) ? 1'b0 :
                                                1'b1 :   // Don't-cares treated as 1
                 (cd == 2'b11) ? (ab == 2'b00) ? 1'b0 :  // cd=11 cases
                                (ab == 2'b01) ? 1'b1 :
                                (ab == 2'b10) ? 1'b1 :
                                                1'b1 :
                                /* cd=10 */   1'b1;      // cd=10 always 1
endmodule