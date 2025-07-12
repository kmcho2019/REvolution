module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = a ? 1'b1 : (c ? (a | ~b) : a);
endmodule