module TopModule(
    input  [7:0] in,  
    output parity    
);

wire [7:0] temp;

assign temp[0] = in[0];
assign temp[1] = temp[0] ^ in[1];
assign temp[2] = temp[1] ^ in[2];
assign temp[3] = temp[2] ^ in[3];
assign temp[4] = temp[3] ^ in[4];
assign temp[5] = temp[4] ^ in[5];
assign temp[6] = temp[5] ^ in[6];
assign temp[7] = temp[6] ^ in[7];

assign parity = temp[7];

endmodule