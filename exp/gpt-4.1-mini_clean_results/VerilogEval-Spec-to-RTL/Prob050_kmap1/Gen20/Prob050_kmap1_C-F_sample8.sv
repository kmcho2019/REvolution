module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Directly implement out as OR of a, b, and c for minimal logic depth and area
    assign out = a | b | c;

endmodule