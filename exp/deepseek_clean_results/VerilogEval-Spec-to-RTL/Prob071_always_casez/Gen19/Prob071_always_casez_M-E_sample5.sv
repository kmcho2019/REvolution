module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [7:0] first_bit_mask;
wire [7:0] one_hot;

// Create a mask where only the first set bit remains
assign first_bit_mask = in & (~in + 1);

// Convert the one-hot mask to binary position
assign one_hot = first_bit_mask;
assign pos = (one_hot[0] ? 3'd0 :
             one_hot[1] ? 3'd1 :
             one_hot[2] ? 3'd2 :
             one_hot[3] ? 3'd3 :
             one_hot[4] ? 3'd4 :
             one_hot[5] ? 3'd5 :
             one_hot[6] ? 3'd6 :
             one_hot[7] ? 3'd7 : 3'd0);

endmodule