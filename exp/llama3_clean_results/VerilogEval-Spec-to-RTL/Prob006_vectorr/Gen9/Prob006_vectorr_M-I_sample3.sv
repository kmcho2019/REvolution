// Module to reverse the bit ordering of an input vector
module TopModule(
    input  [7:0] in,  // Input vector
    output [7:0] out  // Output vector
);

    // Direct assignment to reverse the bit ordering
    assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

endmodule