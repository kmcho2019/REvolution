// Refactored module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Directly assign the reversed bits to the output using a loop
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, a more general and scalable approach would be:
    // generate
    //     for (genvar i = 0; i < 8; i++) begin
    //         assign out[i] = in[7 - i];
    //     end
    // endgenerate

endmodule