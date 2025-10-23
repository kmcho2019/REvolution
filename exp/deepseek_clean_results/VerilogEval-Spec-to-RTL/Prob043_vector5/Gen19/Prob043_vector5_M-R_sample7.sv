module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    assign out = {
        /* a comparisons */ 1'b1,    a ~^ b, a ~^ c, a ~^ d, a ~^ e,
        /* b comparisons */ b ~^ a, 1'b1,    b ~^ c, b ~^ d, b ~^ e,
        /* c comparisons */ c ~^ a, c ~^ b, 1'b1,    c ~^ d, c ~^ e,
        /* d comparisons */ d ~^ a, d ~^ b, d ~^ c, 1'b1,    d ~^ e,
        /* e comparisons */ e ~^ a, e ~^ b, e ~^ c, e ~^ d, 1'b1
    };

endmodule