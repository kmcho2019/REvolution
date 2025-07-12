module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Simplified Boolean expression
    assign out = a | b | c;
endmodule