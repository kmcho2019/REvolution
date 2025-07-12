module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = c ? (a | ~b) : (a & ~d);
endmodule