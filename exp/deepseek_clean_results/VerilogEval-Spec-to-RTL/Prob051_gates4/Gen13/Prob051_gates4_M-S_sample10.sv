module TopModule(input [3:0] in, output out_and, out_or, out_xor);
    assign {out_and,out_or,out_xor}={&in,|in,^in};
endmodule