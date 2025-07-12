module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Select LSB from either a or b based on selector
    assign out = sel ? b[0] : a[0];

endmodule