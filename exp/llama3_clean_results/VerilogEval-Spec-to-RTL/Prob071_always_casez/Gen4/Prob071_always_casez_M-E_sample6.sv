module TopModule(
    input  [7:0] in, 
    output [2:0] pos
);

wire [2:0] pos1, pos2, pos3, pos4;
wire [2:0] sel1, sel2, sel3;

assign pos1 = (in[0])? 3'd0 : 3'd1;
assign sel1 = (in[0])? 3'd0 : 3'd1;

assign pos2 = (in[1])? sel1 : 3'd2;
assign sel2 = (in[1])? sel1 : 3'd2;

assign pos3 = (in[2])? sel2 : 3'd3;
assign sel3 = (in[2])? sel2 : 3'd3;

assign pos4 = (in[3])? sel3 : 3'd4;
assign pos = (in[4])? 3'd4 : 
             (in[5])? 3'd5 : 
             (in[6])? 3'd6 : 
             (in[7])? 3'd7 : pos4;

endmodule