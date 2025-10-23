module TopModule(
    input  a,
    input  b,
    output q
);
assign q = (b == 1'b1)? a : 1'b0;
endmodule