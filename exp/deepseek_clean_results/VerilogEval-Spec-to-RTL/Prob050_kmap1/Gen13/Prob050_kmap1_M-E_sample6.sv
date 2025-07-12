module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire sel;
    assign sel = b | c;
    assign out = sel ? 1'b1 : a;
endmodule