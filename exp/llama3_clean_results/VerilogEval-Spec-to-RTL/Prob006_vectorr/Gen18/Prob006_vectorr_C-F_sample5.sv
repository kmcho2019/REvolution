// Module to reverse the bit ordering of an 8-bit input vector
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use a generate block with a for loop to create the cross-bar connections
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            // Assign each bit of the output to the corresponding reversed bit of the input
            assign out[i] = in[7 - i];
        end
    endgenerate

endmodule