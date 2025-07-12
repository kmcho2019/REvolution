module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    assign out = {
        // a comparisons (row 1)
        1'b1,    a ~^ b,    a ~^ c,    a ~^ d,    a ~^ e,
        // b comparisons (row 2)
        b ~^ a,  1'b1,      b ~^ c,    b ~^ d,    b ~^ e,
        // c comparisons (row 3)
        c ~^ a,  c ~^ b,    1'b1,      c ~^ d,    c ~^ e,
        // d comparisons (row 4)
        d ~^ a,  d ~^ b,    d ~^ c,    1'b1,      d ~^ e,
        // e comparisons (row 5)
        e ~^ a,  e ~^ b,    e ~^ c,    e ~^ d,    1'b1
    };

endmodule