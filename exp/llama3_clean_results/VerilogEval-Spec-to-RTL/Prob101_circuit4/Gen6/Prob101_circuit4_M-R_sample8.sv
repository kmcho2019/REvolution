module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg q
);

always @(*)
    q = b | c;

endmodule