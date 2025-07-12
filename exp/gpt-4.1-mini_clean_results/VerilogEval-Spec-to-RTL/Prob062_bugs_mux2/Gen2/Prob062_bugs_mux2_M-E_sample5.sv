module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Output the LSB of a when sel=0, or LSB of b when sel=1
    assign out = sel ? b[0] : a[0];

endmodule