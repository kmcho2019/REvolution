module TopModule (
    input  a,
    input  b,
    output out
);

    assign out = ~(a | b); // Direct NOR implementation

endmodule