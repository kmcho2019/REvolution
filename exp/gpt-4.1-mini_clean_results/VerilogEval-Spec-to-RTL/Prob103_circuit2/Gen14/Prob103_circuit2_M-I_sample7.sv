module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute even parity using a chain of XNOR gates
    assign q = a ~^ b ~^ c ~^ d;

endmodule