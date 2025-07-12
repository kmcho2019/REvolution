// Parameterized module to reverse the bit ordering of a vector
module TopModule #(
    parameter WIDTH = 8 // Parameter for the width of the input vector
)(
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign out[i] = in[WIDTH-1-i]; // Assign each bit to its reversed position
        end
    endgenerate
endmodule