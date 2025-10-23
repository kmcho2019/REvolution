module TopModule (
    input  [7:0] in,
    output      parity
);

    // Direct XOR of all input bits in one continuous assignment
    assign parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^
                    in[4] ^ in[5] ^ in[6] ^ in[7];

endmodule