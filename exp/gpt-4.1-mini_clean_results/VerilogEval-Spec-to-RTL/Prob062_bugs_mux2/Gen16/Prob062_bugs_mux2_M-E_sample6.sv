module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Output is the least significant bit of selected input
    assign out = sel ? b[0] : a[0];

endmodule