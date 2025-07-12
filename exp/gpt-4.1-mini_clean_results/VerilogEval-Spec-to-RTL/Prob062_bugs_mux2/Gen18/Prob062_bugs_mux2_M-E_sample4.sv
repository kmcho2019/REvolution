module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    wire [7:0] muxed;
    assign muxed = sel ? b : a;
    assign out = |muxed;  // Reduction OR of the selected input vector

endmodule