module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct continuous assignment implementing out = a OR b OR c
    assign out = a | b | c;

endmodule