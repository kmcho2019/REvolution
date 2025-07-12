module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire all_zero = ~a & ~b & ~c;
    assign out = all_zero ? 1'b0 : 1'b1;
endmodule