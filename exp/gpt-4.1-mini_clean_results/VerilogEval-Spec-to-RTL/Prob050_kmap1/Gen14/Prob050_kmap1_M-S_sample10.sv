module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Directly assign the OR of all three inputs
    assign out = a | b | c;

endmodule