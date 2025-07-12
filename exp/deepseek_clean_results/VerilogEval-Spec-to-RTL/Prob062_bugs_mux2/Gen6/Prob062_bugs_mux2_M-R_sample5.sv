module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Select LSB from chosen 8-bit input based on sel
    assign out = sel ? b[0] : a[0];

endmodule