// Module to reverse the bit ordering of an input vector
module TopModule(
    input  [7:0] in,  // Input vector
    output [7:0] out // Output vector
);

    // Define a parameter for the width of the input and output ports
    parameter WIDTH = 8;

    // Use a generate block with a for loop to reverse the bit ordering
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            // Assign each bit of the output to the corresponding reversed bit of the input
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate

endmodule