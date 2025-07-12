module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Directly assign out as the OR of inputs a, b, and c
    assign out = a | b | c;
endmodule