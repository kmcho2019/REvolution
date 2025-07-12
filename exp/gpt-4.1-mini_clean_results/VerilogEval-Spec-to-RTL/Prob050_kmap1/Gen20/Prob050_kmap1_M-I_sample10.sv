// TopModule implements the Karnaugh map logic: out = a + b + c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Minimal and optimal implementation using continuous assignment
    assign out = a | b | c;
endmodule