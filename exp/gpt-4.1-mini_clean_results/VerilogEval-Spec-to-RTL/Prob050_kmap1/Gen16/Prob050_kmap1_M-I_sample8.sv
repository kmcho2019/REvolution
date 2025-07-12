module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Directly assign the OR of all inputs
    assign out = a | b | c;
endmodule