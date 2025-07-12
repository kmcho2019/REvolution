module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Single continuous assignment implementation
    assign out = a | b | c;
endmodule