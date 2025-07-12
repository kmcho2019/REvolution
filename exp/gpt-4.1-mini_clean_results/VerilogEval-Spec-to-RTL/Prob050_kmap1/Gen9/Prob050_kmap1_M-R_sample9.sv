module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct continuous assignment implements out = a OR b OR c
    assign out = a | b | c;

endmodule