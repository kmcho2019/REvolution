module TopModule(
    input a,
    input b,
    input c,
    output out
);

assign out = (b) || (!b && !c && a);

endmodule