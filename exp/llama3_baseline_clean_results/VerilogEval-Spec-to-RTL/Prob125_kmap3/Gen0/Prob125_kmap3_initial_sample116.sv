module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (a & ~c & ~d) ? 0 :
             (a | (b & c) | (~a & ~b & c)) ? 1 : 1;

endmodule