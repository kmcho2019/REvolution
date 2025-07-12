module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Direct 3-input OR using continuous assignment for minimal gates and delay
    assign out = a | b | c;

endmodule