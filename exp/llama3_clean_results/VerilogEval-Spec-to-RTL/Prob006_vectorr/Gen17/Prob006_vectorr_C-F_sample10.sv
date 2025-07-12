// Module to reverse the bit ordering of a word using a generate block and parameters
module TopModule(
    input  [WORD_SIZE - 1:0] in,  // Input vector of parameterized size
    output [WORD_SIZE - 1:0] out // Output vector of the same size as input
);

    // Parameters for the word size and shift amount
    parameter WORD_SIZE = 8;
    parameter SHIFT_AMOUNT = WORD_SIZE - 1;

    // Internal wires to hold the reversed bits
    wire [WORD_SIZE - 1:0] reversed_bits;

    // Generate the reversed bits
    genvar i;
    generate
        for (i = 0; i < WORD_SIZE; i = i + 1) begin
            assign reversed_bits[i] = in[WORD_SIZE - 1 - i];
        end
    endgenerate

    // Output the reversed bits
    assign out = reversed_bits;

endmodule