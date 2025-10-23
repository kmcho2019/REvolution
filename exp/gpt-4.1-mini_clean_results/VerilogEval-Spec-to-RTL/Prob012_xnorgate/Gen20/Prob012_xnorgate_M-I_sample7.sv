module TopModule(
    input  wire a,
    input  wire b,
    output wire out
);
    // Implement XNOR with direct continuous assignment for best PPA
    assign out = a ~^ b;
endmodule