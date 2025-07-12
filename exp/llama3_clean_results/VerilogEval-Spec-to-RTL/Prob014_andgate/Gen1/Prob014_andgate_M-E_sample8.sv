module TopModule(
    input  a,
    input  b,
    output out
);

assign out = (a == 1'b0) ? 1'b0 : b;

endmodule