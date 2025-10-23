module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Systematic grouping of all pairwise comparisons using XNOR
    // Each group compares one input against all inputs (including itself)
    // Self-comparisons are explicitly shown as they optimize to constant 1
    assign out[24:20] = {
        1'b1,      // a == a
        a ~^ b,
        a ~^ c,
        a ~^ d,
        a ~^ e
    };

    assign out[19:15] = {
        b ~^ a,
        1'b1,      // b == b
        b ~^ c,
        b ~^ d,
        b ~^ e
    };

    assign out[14:10] = {
        c ~^ a,
        c ~^ b,
        1'b1,      // c == c
        c ~^ d,
        c ~^ e
    };

    assign out[9:5] = {
        d ~^ a,
        d ~^ b,
        d ~^ c,
        1'b1,      // d == d
        d ~^ e
    };

    assign out[4:0] = {
        e ~^ a,
        e ~^ b,
        e ~^ c,
        e ~^ d,
        1'b1       // e == e
    };

endmodule