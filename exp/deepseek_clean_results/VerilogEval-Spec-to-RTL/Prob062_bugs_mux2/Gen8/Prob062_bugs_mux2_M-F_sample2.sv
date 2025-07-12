module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    assign out = sel ? b[0] : a[0];  // Select bit 0 from either a or b

endmodule