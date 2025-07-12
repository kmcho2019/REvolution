module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct assignment implements out = a | b | c
    assign out = a | b | c;

endmodule