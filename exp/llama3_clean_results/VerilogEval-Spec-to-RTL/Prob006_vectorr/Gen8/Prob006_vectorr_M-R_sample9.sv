// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use a generate block with a for-loop to reverse the bit ordering
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign out[i] = in[7 - i];
        end
    endgenerate

endmodule