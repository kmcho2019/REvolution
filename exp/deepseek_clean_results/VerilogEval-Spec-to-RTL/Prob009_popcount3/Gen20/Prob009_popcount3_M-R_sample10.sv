module TopModule (
    input [2:0] in,
    output [1:0] out
);

    wire pair01, pair02, pair12;
    
    // Calculate all pairwise ANDs
    assign pair01 = in[0] & in[1];
    assign pair02 = in[0] & in[2];
    assign pair12 = in[1] & in[2];
    
    // MSB: At least two pairs are 1
    assign out[1] = pair01 | pair02 | pair12;
    
    // LSB: XOR remains the same but now more explicit
    assign out[0] = in[0] ^ in[1] ^ in[2];

endmodule