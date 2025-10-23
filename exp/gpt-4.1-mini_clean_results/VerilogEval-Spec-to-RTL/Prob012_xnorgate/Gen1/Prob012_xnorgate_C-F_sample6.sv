module TopModule (
    input  a,
    input  b,
    output out
);
    // Implement XNOR gate: out is 1 if a and b are equal
    assign out = a ~^ b; 
endmodule