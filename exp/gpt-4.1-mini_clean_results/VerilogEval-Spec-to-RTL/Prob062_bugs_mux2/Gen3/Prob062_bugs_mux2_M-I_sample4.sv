module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Output is the selected bit 0 from a or b
    assign out = sel ? b[0] : a[0];

endmodule