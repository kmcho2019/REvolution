module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    assign out = {
        // a comparisons (a vs a,b,c,d,e)
        a ~^ a, a ~^ b, a ~^ c, a ~^ d, a ~^ e,
        // b comparisons (b vs a,b,c,d,e)
        b ~^ a, b ~^ b, b ~^ c, b ~^ d, b ~^ e,
        // c comparisons (c vs a,b,c,d,e)
        c ~^ a, c ~^ b, c ~^ c, c ~^ d, c ~^ e,
        // d comparisons (d vs a,b,c,d,e)
        d ~^ a, d ~^ b, d ~^ c, d ~^ d, d ~^ e,
        // e comparisons (e vs a,b,c,d,e)
        e ~^ a, e ~^ b, e ~^ c, e ~^ d, e ~^ e
    };

endmodule