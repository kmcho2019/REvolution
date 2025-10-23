module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Grouped assignments showing the 5x5 comparison matrix
    // Diagonal elements (self-comparisons) set to constant 1
    assign out[24:20] = {1'b1,      a ~^ b, a ~^ c, a ~^ d, a ~^ e};
    assign out[19:15] = {b ~^ a, 1'b1,      b ~^ c, b ~^ d, b ~^ e};
    assign out[14:10] = {c ~^ a, c ~^ b, 1'b1,      c ~^ d, c ~^ e};
    assign out[ 9: 5] = {d ~^ a, d ~^ b, d ~^ c, 1'b1,      d ~^ e};
    assign out[ 4: 0] = {e ~^ a, e ~^ b, e ~^ c, e ~^ d, 1'b1     };

endmodule