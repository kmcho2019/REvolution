module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              sel,
    output [WIDTH-1:0] out
);

    // Single continuous assignment for all bits
    assign out = sel ? b : a;

endmodule