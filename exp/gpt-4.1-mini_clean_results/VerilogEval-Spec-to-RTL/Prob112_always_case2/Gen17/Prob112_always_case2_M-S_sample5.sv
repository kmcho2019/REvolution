module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

assign pos = (in == 4'b0000) ? 2'd0 : 
             (in[0]) ? 2'd0 :
             (in[1]) ? 2'd1 :
             (in[2]) ? 2'd2 :
             2'd3;

endmodule