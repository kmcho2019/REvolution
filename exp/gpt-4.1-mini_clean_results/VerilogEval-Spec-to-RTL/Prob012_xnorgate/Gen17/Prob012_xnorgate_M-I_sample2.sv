module TopModule(
    input  a,
    input  b,
    output /* synthesis keep = "true" */ out
);
    // Directly implement XNOR with continuous assignment for best PPA
    assign out = a ~^ b;
endmodule