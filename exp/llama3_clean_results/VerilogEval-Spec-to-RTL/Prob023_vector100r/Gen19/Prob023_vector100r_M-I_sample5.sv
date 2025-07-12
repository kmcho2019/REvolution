module TopModule #(
    // Parameter for the width of the input and output
    parameter WIDTH = 100
) (
    // Input signal
    input  [WIDTH-1:0] in,
    // Output signal with reversed bit order
    output [WIDTH-1:0] out
);

    // Use a simple array manipulation technique to reverse the bits
    assign out = {<< {WIDTH{1'b0}}} in;

    // Alternatively, you can use the following syntax
    // assign out = in[WIDTH-1:0];

endmodule