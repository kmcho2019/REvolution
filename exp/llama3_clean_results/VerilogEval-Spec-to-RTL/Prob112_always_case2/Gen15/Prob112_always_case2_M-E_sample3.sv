module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

wire pos_0, pos_1;

assign pos_0 = (in[1] | in[2] | in[3]) ? 1'b0 : in[0];
assign pos_1 = (in[2] | in[3]) ? 1'b0 : (in[1] ? 1'b1 : 1'b0);

assign pos = {pos_1, pos_0};

endmodule