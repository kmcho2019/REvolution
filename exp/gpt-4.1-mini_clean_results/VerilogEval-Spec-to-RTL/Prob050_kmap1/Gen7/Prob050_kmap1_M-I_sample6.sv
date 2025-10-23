module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Directly assign the output as OR of inputs
    assign out = a | b | c;

endmodule