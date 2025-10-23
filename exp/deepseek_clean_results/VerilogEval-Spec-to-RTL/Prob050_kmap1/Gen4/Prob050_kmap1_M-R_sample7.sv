module TopModule(
    input a,
    input b,
    input c,
    output out
);
    assign out = (a == 0 && b == 0 && c == 0) ? 1'b0 : 1'b1;
endmodule