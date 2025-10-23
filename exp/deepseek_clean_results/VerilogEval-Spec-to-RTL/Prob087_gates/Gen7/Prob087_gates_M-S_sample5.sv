module TopModule(input a,b,output out_and,out_or,out_xor,out_nand,out_nor,out_xnor,out_anotb);
assign out_and=a&b;
assign out_or=a|b;
assign out_xor=a^b;
assign out_nand=~(a&b);
assign out_nor=~(a|b);
assign out_xnor=~(a^b);
assign out_anotb=a&~b;
endmodule