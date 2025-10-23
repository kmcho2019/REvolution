// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Directly assign the bits of out by reversing the index of in
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, you can use the following syntax to reverse the bits
    // assign out = in[7:0];

    // Or, you can use the following syntax to reverse the bits
    // assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

    // However, the above alternative syntax does not explicitly show the reversal process
    // So, we will use the first syntax to keep the code simple and clear

endmodule