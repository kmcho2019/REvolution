module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);
    assign out = {
        // a comparisons (5 bits)
        1'b1,    a ~^ b,    a ~^ c,    a ~^ d,    a ~^ e,
        
        // b comparisons (5 bits)
        b ~^ a,  1'b1,      b ~^ c,    b ~^ d,    b ~^ e,
        
        // c comparisons (5 bits)
        c ~^ a,  c ~^ b,    1'b1,      c ~^ d,    c ~^ e,
        
        // d comparisons (5 bits)
        d ~^ a,  d ~^ b,    d ~^ c,    1'b1,      d ~^ e,
        
        // e comparisons (5 bits)
        e ~^ a,  e ~^ b,    e ~^ c,    e ~^ d,    1'b1
    };
endmodule