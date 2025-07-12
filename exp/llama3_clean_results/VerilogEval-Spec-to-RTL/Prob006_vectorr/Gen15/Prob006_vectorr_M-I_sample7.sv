// Module to reverse the bit ordering of an input vector
module TopModule(
    input  [7:0] in,  // Input vector
    output [7:0] out // Output vector
);

    // Define a parameter for the width of the input and output ports
    parameter WIDTH = 8;

    // Use a simple continuous assignment statement to reverse the bit ordering
    assign out = in[WIDTH - 1:0];

endmodule