module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Directly assign the XNOR of inputs to output using the built-in operator
    assign out = a ~^ b;
endmodule