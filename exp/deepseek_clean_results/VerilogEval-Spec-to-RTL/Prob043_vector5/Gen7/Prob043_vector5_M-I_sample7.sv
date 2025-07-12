module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Systematic 5x5 comparison matrix (5 inputs x 5 inputs)
    // Each group compares one input against all inputs (including itself)
    assign out[24:20] = {1'b1,       // a == a (always true)
                         a ~^ b,     // a == b
                         a ~^ c,      // a == c
                         a ~^ d,      // a == d
                         a ~^ e};     // a == e
    
    assign out[19:15] = {b ~^ a,     // b == a
                         1'b1,       // b == b
                         b ~^ c,      // b == c
                         b ~^ d,      // b == d
                         b ~^ e};     // b == e
    
    assign out[14:10] = {c ~^ a,     // c == a
                         c ~^ b,     // c == b
                         1'b1,       // c == c
                         c ~^ d,      // c == d
                         c ~^ e};     // c == e
    
    assign out[ 9: 5] = {d ~^ a,     // d == a
                         d ~^ b,     // d == b
                         d ~^ c,     // d == c
                         1'b1,       // d == d
                         d ~^ e};    // d == e
    
    assign out[ 4: 0] = {e ~^ a,     // e == a
                         e ~^ b,     // e == b
                         e ~^ c,     // e == c
                         e ~^ d,     // e == d
                         1'b1};      // e == e

endmodule