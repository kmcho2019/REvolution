module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Output LSB of selected input (a when sel=0, b when sel=1)
    assign out = sel ? b[0] : a[0];

endmodule