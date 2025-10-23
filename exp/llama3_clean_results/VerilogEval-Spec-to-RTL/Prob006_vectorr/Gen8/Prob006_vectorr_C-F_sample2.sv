// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Reverse the bit ordering of the input and assign it to the output
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, a generate block with a for loop can be used for more complex bit widths
    // genvar i;
    // generate
    //     for (i = 0; i < 8; i++) begin
    //         assign out[i] = in[7 - i];
    //     end
    // endgenerate

endmodule