module TopModule (
    input [2:0] in,
    output [1:0] out
);
    wire xor01 = in[0] ^ in[1];
    
    assign out[0] = xor01 ^ in[2];  // LSB: odd parity
    assign out[1] = (in[0] & in[1]) | (in[2] & xor01);  // MSB: majority function
endmodule