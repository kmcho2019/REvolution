module TopModule (
    input  a,
    input  b,
    output out
);

    // Direct behavioral implementation of NOR using assign
    assign out = ~(a | b);

endmodule