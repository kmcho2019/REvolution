// Module to reverse the bit ordering of an 8-bit input using a cross-bar switch approach
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Create a cross-bar switch to connect input bits to output bits in reverse order
    assign out[0] = in[7];
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];

    // Alternatively, we can use a loop to generate the cross-bar connections
    // generate
    //     genvar i;
    //     for (i = 0; i < 8; i = i + 1) begin
    //         assign out[i] = in[7 - i];
    //     end
    // endgenerate

endmodule