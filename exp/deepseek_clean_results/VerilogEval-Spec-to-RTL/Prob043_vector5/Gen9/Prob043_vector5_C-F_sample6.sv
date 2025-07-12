module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Self-comparisons (always true)
    assign out[24] = 1'b1;  // a == a
    assign out[18] = 1'b1;  // b == b
    assign out[12] = 1'b1;  // c == c
    assign out[6]  = 1'b1;  // d == d
    assign out[0]  = 1'b1;  // e == e

    // Grouped comparisons using concatenation
    assign out[23:20] = {a ~^ b, a ~^ c, a ~^ d, a ~^ e};  // a vs others
    assign out[19:15] = {b ~^ a, b ~^ c, b ~^ d, b ~^ e};  // b vs others
    assign out[17:10] = {c ~^ a, c ~^ b, c ~^ d, c ~^ e};  // c vs others
    assign out[14:5]  = {d ~^ a, d ~^ b, d ~^ c, d ~^ e};  // d vs others
    assign out[9:1]   = {e ~^ a, e ~^ b, e ~^ c, e ~^ d};  // e vs others

endmodule