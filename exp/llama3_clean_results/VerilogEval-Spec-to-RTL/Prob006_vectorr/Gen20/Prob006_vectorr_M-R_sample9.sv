// Module to reverse the bit ordering of an 8-bit input using a generate block
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use a generate block to assign the bits of the output vector in reverse order
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign out[i] = in[7 - i];
        end
    endgenerate

endmodule