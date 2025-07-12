module TopModule(input clk,input resetn,input in,output out);
reg [3:0] s;
always @(posedge clk) s <= !resetn ? 0 : {s[2:0],in};
assign out = s[3];
endmodule