// Module to reverse the bit ordering of an input vector
module TopModule(
    input  [7:0] in,  // Input vector
    output [7:0] out // Output vector
);

    // Directly reverse the input vector and assign it to the output vector
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, a more concise way to achieve the same result is to use the following syntax:
    // assign out = in[7:0];

    // However, to explicitly reverse the bits, the following approach can be used:
    assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

endmodule