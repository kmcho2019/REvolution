module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [7:0] masked_bits;
wire [2:0] pos0, pos1, pos2, pos3;

// Masking logic - each bit is only considered if all higher bits are 0
assign masked_bits[0] = in[0];
assign masked_bits[1] = in[1] & ~|in[7:2];
assign masked_bits[2] = in[2] & ~|in[7:3];
assign masked_bits[3] = in[3] & ~|in[7:4];
assign masked_bits[4] = in[4] & ~|in[7:5];
assign masked_bits[5] = in[5] & ~|in[7:6];
assign masked_bits[6] = in[6] & ~in[7];
assign masked_bits[7] = in[7];

// Position encoding
assign pos0 = masked_bits[1] ? 3'd1 :
              masked_bits[3] ? 3'd3 :
              masked_bits[5] ? 3'd5 :
              masked_bits[7] ? 3'd7 : 3'd0;
              
assign pos1 = masked_bits[2] ? 3'd2 :
              masked_bits[3] ? 3'd3 :
              masked_bits[6] ? 3'd6 :
              masked_bits[7] ? 3'd7 : 3'd0;
              
assign pos2 = masked_bits[4] ? 3'd4 :
              masked_bits[5] ? 3'd5 :
              masked_bits[6] ? 3'd6 :
              masked_bits[7] ? 3'd7 : 3'd0;

// Combine position bits
assign pos = {|masked_bits[7:4], |{masked_bits[7:6], masked_bits[3:2]}, |{masked_bits[7], masked_bits[5], masked_bits[3], masked_bits[1]}};

endmodule