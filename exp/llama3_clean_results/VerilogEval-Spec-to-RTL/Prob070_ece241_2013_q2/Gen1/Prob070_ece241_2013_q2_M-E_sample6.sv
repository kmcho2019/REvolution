module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Encode input conditions
wire [3:0] encoded_input;
assign encoded_input = {a, b, c, d};

// Decoder for out_sop
wire [3:0] sop_decoded;
assign sop_decoded[0] = !encoded_input[3] & !encoded_input[2] & encoded_input[1] & encoded_input[0]; // 2
assign sop_decoded[1] = !encoded_input[3] & encoded_input[2] & encoded_input[1] & encoded_input[0]; // 7
assign sop_decoded[2] = encoded_input[3] & encoded_input[2] & encoded_input[1] & encoded_input[0]; // 15
assign sop_decoded[3] = 1'b0; // unused

// 4-to-1 multiplexer for out_sop
assign out_sop = sop_decoded[0] | sop_decoded[1] | sop_decoded[2];

// Decoder for out_pos
wire [3:0] pos_decoded;
assign pos_decoded[0] = encoded_input[3] | encoded_input[2] | encoded_input[1] | !encoded_input[0]; // 0
assign pos_decoded[1] = encoded_input[3] | encoded_input[2] | !encoded_input[1] | !encoded_input[0]; // 1
assign pos_decoded[2] = encoded_input[3] | !encoded_input[2] | encoded_input[1] | !encoded_input[0]; // 4
assign pos_decoded[3] = encoded_input[3] | !encoded_input[2] | encoded_input[1] | encoded_input[0]; // 5

wire [7:4] pos_decoded_more;
assign pos_decoded_more[4] = encoded_input[3] | !encoded_input[2] | !encoded_input[1] | !encoded_input[0]; // 6
assign pos_decoded_more[5] = !encoded_input[3] | encoded_input[2] | !encoded_input[1] | !encoded_input[0]; // 9
assign pos_decoded_more[6] = !encoded_input[3] | encoded_input[2] | !encoded_input[1] | encoded_input[0]; // 10
assign pos_decoded_more[7] = !encoded_input[3] | !encoded_input[2] | encoded_input[1] | encoded_input[0]; // 13

wire [3:0] pos_decoded_even_more;
assign pos_decoded_even_more[0] = !encoded_input[3] | !encoded_input[2] | encoded_input[1] | !encoded_input[0]; // 12
assign pos_decoded_even_more[1] = encoded_input[3] | encoded_input[2] | !encoded_input[1] | encoded_input[0]; // 14
assign pos_decoded_even_more[2] = encoded_input[3] | encoded_input[2] | encoded_input[1] | !encoded_input[0]; // 14
assign pos_decoded_even_more[3] = 1'b0; // unused

// 4-to-1 multiplexer for out_pos
assign out_pos = !(pos_decoded[0] | pos_decoded[1] | pos_decoded[2] | pos_decoded[3] | pos_decoded_more[4] | pos_decoded_more[5] | pos_decoded_more[6] | pos_decoded_more[7] | pos_decoded_even_more[0] | pos_decoded_even_more[1] | pos_decoded_even_more[2]);

endmodule