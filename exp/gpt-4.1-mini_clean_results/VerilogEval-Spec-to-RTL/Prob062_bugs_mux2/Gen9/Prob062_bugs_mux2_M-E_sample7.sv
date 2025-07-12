module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    wire [7:0] selected = sel ? b : a;
    assign out = |selected; // bitwise OR reduction to produce single bit output

endmodule