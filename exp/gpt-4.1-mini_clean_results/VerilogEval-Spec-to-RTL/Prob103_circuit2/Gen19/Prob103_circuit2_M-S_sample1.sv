module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    assign q = a ~^ b ~^ c ~^ d; // Simplified even parity output using XNOR chain

endmodule