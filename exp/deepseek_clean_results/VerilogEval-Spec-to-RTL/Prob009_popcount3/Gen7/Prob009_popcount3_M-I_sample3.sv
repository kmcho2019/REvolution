module TopModule #(
    parameter WIDTH = 3
) (
    input [WIDTH-1:0] in,
    output [1:0] out
);

    // Population count (number of 1's) for parameterized width input
    // Optimal implementation using direct bit summation for small widths
    assign out = in[0] + in[1] + in[2];

endmodule