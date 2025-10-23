module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    assign out = in[::-1]; // Reverse the bits of 'in' and assign to 'out'

endmodule