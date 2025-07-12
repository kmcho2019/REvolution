module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire all_zero;
    assign all_zero = ~(a | b | c);
    assign out = ~all_zero;
endmodule