module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    assign out = {
        // a comparisons
        a ~^ a, a ~^ b, a ~^ c, a ~^ d, a ~^ e,
        // b comparisons
        b ~^ a, b ~^ b, b ~^ c, b ~^ d, b ~^ e,
        // c comparisons
        c ~^ a, c ~^ b, c ~^ c, c ~^ d, c ~^ e,
        // d comparisons
        d ~^ a, d ~^ b, d ~^ c, d ~^ d, d ~^ e,
        // e comparisons
        e ~^ a, e ~^ b, e ~^ c, e ~^ d, e ~^ e
    };

endmodule