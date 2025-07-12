module TopModule(
    input  [7:0] in,  
    output parity    
);

// Break down the 8-bit input into smaller groups and compute the XOR of these groups
wire xor_group1, xor_group2, xor_group3, xor_group4;

assign xor_group1 = in[0] ^ in[1];
assign xor_group2 = in[2] ^ in[3];
assign xor_group3 = in[4] ^ in[5];
assign xor_group4 = in[6] ^ in[7];

// Finally, XOR the results of the groups to obtain the parity bit
assign parity = (xor_group1 ^ xor_group2) ^ (xor_group3 ^ xor_group4);

endmodule