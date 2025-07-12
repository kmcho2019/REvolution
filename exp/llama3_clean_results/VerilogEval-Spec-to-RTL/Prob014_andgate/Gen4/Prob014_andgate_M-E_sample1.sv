module TopModule(
    input  a,
    input  b,
    output out
);

assign out = (b)? a : 1'b0;

endmodule