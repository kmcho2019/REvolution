module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire b_or_c;
    assign b_or_c = b | c;
    assign out = a | b_or_c;
endmodule