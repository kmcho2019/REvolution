module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);
    // Self comparisons (always 1)
    assign out[24] = 1'b1;
    assign out[18] = 1'b1;
    assign out[12] = 1'b1;
    assign out[6]  = 1'b1;
    assign out[0]  = 1'b1;

    // a comparisons
    assign out[23:20] = {a == b, a == c, a == d, a == e};
    
    // b comparisons (excluding b==a which is same as a==b)
    assign out[17:15] = {b == c, b == d, b == e};
    
    // c comparisons
    assign out[14:10] = {c == a, c == b, 1'b1, c == d, c == e};
    
    // d comparisons
    assign out[9:5] = {d == a, d == b, d == c, 1'b1, d == e};
    
    // e comparisons
    assign out[4:1] = {e == a, e == b, e == c, e == d};
endmodule