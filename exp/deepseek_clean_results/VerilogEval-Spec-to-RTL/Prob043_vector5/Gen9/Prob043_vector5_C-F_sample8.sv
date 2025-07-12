module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    assign out = {
        // a compared with all inputs (a-e)
        a ~^ a, a ~^ b, a ~^ c, a ~^ d, a ~^ e,
        // b compared with all inputs (a-e)
        b ~^ a, b ~^ b, b ~^ c, b ~^ d, b ~^ e,
        // c compared with all inputs (a-e)
        c ~^ a, c ~^ b, c ~^ c, c ~^ d, c ~^ e,
        // d compared with all inputs (a-e)
        d ~^ a, d ~^ b, d ~^ c, d ~^ d, d ~^ e,
        // e compared with all inputs (a-e)
        e ~^ a, e ~^ b, e ~^ c, e ~^ d, e ~^ e
    };

endmodule