module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = a ? 1'b1 : (c ? ~b : 1'b0);
endmodule