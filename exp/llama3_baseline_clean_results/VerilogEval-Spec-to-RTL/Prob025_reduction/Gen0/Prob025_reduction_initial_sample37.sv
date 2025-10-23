module TopModule(
    input  [7:0] in,  // input byte (8 bits)
    output parity    // output parity bit
);

assign parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];

endmodule