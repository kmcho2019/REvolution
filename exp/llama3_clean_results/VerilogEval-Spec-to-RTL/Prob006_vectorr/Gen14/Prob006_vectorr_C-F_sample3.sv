// Module to reverse the bit ordering of an input vector
module TopModule #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);

    // Use a generate block with a for loop to reverse the bit ordering
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            // Assign each bit of the output to the corresponding reversed bit of the input
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate

endmodule