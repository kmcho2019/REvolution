// Refactored module to reverse the bit ordering of an 8-bit input using array indexing
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Reverse the bit ordering of the input vector using array indexing
    assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

    // Alternatively, we can use a more general and flexible approach
    // that works for any input size by utilizing a loop in a generate block
    // generate
    //     genvar i;
    //     for (i = 0; i < 8; i = i + 1) begin
    //         assign out[i] = in[7 - i];
    //     end
    // endgenerate

endmodule