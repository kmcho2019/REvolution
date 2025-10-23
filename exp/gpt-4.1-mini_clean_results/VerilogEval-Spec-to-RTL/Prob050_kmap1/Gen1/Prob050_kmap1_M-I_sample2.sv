module TopModule(
    input a,
    input b,
    input c,
    output out
);
    assign out = (a ? 1'b1 : (b ? 1'b1 : c));
endmodule