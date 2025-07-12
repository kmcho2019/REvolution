module TopModule(
    input  a,
    input  b,
    output out
);

    // Internal wires for the AND operations
    wire same_00, same_11;

    // AND operations to check for same inputs (00 or 11)
    assign same_00 = ~(a) & ~(b);
    assign same_11 = a & b;

    // OR operation to combine the results of the AND operations
    assign out = same_00 | same_11;

endmodule