module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Directly assign the XNOR of a and b to out
    assign out = a ~^ b;
endmodule