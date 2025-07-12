module TopModule(input [3:0] in, output out_and, out_or, out_xor);
    assign out_and=&in,out_or=|in,out_xor=^in;
endmodule