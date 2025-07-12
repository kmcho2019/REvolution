module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out represents the 2-bit population count of 'in'
    // out[0] is the parity bit (LSB): number of ones mod 2
    assign out[0] = in[0] ^ in[1] ^ in[2];

    // out[1] is the majority bit (MSB): 1 if two or more inputs are 1
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[2] & in[0]);

endmodule