module TopModule #(
    // Parameter for the width of the input and output
    parameter WIDTH = 100
) (
    // Input signal
    input  [WIDTH-1:0] in,
    // Output signal with reversed bit order
    output [WIDTH-1:0] out
);

    // Directly assign the reversed input bits to the output
    assign out = { >> {in} };

endmodule