module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    wire [7:0] selected;
    assign selected = sel ? b : a;
    assign out = |selected;  // Reduction OR of all bits in selected input

endmodule