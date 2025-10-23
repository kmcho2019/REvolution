module TopModule(
    input a,
    input b,
    input c, // unused in this expression, but included in interface
    input d,
    output out
);

assign out = (~a & ~b) | (b & ~d) | (a & d);

endmodule