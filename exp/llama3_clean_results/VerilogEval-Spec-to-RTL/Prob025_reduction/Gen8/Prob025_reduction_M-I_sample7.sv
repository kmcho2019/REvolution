module TopModule(
    input  [7:0] in,  
    output parity    
);

// Divide the input into two groups of 4 bits
wire group1_xor;
assign group1_xor = in[0] ^ in[1] ^ in[2] ^ in[3];

wire group2_xor;
assign group2_xor = in[4] ^ in[5] ^ in[6] ^ in[7];

// Compute the final parity by XORing the two group results
assign parity = group1_xor ^ group2_xor;

endmodule