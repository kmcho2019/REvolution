module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Population count using explicit logic gates
    assign out[0] = in[0] ^ in[1] ^ in[2];  // LSB: odd parity
    assign out[1] = (in[0] & in[1]) |       // MSB: at least two 1's
                    (in[1] & in[2]) | 
                    (in[0] & in[2]);

endmodule