module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Output is the OR-reduction of selected input vector
    assign out = sel ? |b : |a;

endmodule