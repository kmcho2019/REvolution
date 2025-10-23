module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    assign out = {
        // Row 1: a vs [a b c d e]
        1'b1,    a ~^ b,    a ~^ c,    a ~^ d,    a ~^ e,
        // Row 2: b vs [a b c d e]
        b ~^ a,    1'b1,    b ~^ c,    b ~^ d,    b ~^ e,
        // Row 3: c vs [a b c d e]
        c ~^ a,    c ~^ b,    1'b1,    c ~^ d,    c ~^ e,
        // Row 4: d vs [a b c d e]
        d ~^ a,    d ~^ b,    d ~^ c,    1'b1,    d ~^ e,
        // Row 5: e vs [a b c d e]
        e ~^ a,    e ~^ b,    e ~^ c,    e ~^ d,    1'b1
    };

endmodule