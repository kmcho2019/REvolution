module TopModule (
    input  a,
    input  b,
    output out
);

    // Implement NOR using reduction NOR operator on inputs a and b
    assign out = ~(a | b);

endmodule