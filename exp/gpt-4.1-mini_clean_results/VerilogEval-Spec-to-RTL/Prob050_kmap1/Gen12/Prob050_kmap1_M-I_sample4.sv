module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Direct minimal implementation for optimal PPA:
    assign out = a | b | c;
endmodule