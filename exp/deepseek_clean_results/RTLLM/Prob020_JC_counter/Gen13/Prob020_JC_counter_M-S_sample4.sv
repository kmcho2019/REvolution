module JC_counter(input clk,rst_n,output reg[63:0]Q);
always@(posedge clk or negedge rst_n)Q<=!rst_n?0:{~Q[0],Q[63:1]};
endmodule