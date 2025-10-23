module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Intermediate signals for pairwise ANDs
    wire and01 = in[0] & in[1];
    wire and12 = in[1] & in[2];
    wire and02 = in[0] & in[2];
    
    // Population count outputs
    assign out[0] = in[0] ^ in[1] ^ in[2];  // LSB: XOR of all bits
    assign out[1] = and01 | and12 | and02;  // MSB: any two bits set
endmodule