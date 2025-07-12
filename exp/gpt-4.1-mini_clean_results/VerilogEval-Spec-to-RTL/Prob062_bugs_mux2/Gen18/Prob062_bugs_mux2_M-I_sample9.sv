module TopModule #(
    parameter WIDTH = 8
) (
    input                    sel,
    input      [WIDTH-1:0]   a,
    input      [WIDTH-1:0]   b,
    output     [WIDTH-1:0]   out
);

    // Parameterized 2-to-1 multiplexer for any bit-width
    assign out = sel ? b : a;

endmodule