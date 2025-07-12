module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [1:0] pair0_sel = {in[1], in[0]};
wire [1:0] pair1_sel = {in[3], in[2]};
wire [1:0] pair2_sel = {in[5], in[4]};
wire [1:0] pair3_sel = {in[7], in[6]};

wire pair0_has1 = |pair0_sel;
wire pair1_has1 = |pair1_sel;
wire pair2_has1 = |pair2_sel;
wire pair3_has1 = |pair3_sel;

wire [1:0] first_pair = 
    pair0_has1 ? 2'b00 :
    pair1_has1 ? 2'b01 :
    pair2_has1 ? 2'b10 :
    2'b11;

wire [1:0] selected_pair = 
    (first_pair == 2'b00) ? pair0_sel :
    (first_pair == 2'b01) ? pair1_sel :
    (first_pair == 2'b10) ? pair2_sel :
    pair3_sel;

wire [1:0] bit_in_pair = 
    selected_pair[0] ? 2'b00 :
    selected_pair[1] ? 2'b01 :
    2'b00;

assign pos = (|in) ? {first_pair, bit_in_pair[0]} : 3'b000;

endmodule