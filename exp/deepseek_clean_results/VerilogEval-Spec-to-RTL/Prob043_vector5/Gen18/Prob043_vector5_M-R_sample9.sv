module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);

    // All 25 pairwise comparisons listed explicitly
    assign out[24] = a ~^ a;  // a vs a
    assign out[23] = a ~^ b;  // a vs b
    assign out[22] = a ~^ c;  // a vs c
    assign out[21] = a ~^ d;  // a vs d
    assign out[20] = a ~^ e;  // a vs e
    
    assign out[19] = b ~^ a;  // b vs a
    assign out[18] = b ~^ b;  // b vs b
    assign out[17] = b ~^ c;  // b vs c
    assign out[16] = b ~^ d;  // b vs d
    assign out[15] = b ~^ e;  // b vs e
    
    assign out[14] = c ~^ a;  // c vs a
    assign out[13] = c ~^ b;  // c vs b
    assign out[12] = c ~^ c;  // c vs c
    assign out[11] = c ~^ d;  // c vs d
    assign out[10] = c ~^ e;  // c vs e
    
    assign out[9]  = d ~^ a;  // d vs a
    assign out[8]  = d ~^ b;  // d vs b
    assign out[7]  = d ~^ c;  // d vs c
    assign out[6]  = d ~^ d;  // d vs d
    assign out[5]  = d ~^ e;  // d vs e
    
    assign out[4]  = e ~^ a;  // e vs a
    assign out[3]  = e ~^ b;  // e vs b
    assign out[2]  = e ~^ c;  // e vs c
    assign out[1]  = e ~^ d;  // e vs d
    assign out[0]  = e ~^ e;  // e vs e

endmodule