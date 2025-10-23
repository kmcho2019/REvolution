// Simplified module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Directly reverse the input bits and assign to the output
    assign out = in[7:0];

endmodule