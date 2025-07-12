module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector (reversed input)
);

    // Directly assign the reversed input vector to the output
    assign out = in[WIDTH-1:0];

endmodule