module TopModule #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    assign out = in;

endmodule