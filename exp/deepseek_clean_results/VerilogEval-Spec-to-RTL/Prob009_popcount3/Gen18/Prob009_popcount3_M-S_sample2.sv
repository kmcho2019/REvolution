module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Simplified population count using direct logic
    assign out[0] = in[0] ^ in[1] ^ in[2];          // LSB: odd count
    assign out[1] = (in[0] & in[1]) |              // MSB: count >= 2
                    (in[1] & in[2]) | 
                    (in[0] & in[2]);
endmodule