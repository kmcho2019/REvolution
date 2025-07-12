module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct OR of inputs without extra modules
    assign out = a | b | c;

endmodule