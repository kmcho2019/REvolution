// TopModule: computes the parity bit for an 8-bit byte using "even" parity
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // parity bit
);

    // Compute the parity bit by XORing all 8 input bits
    assign parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];

endmodule