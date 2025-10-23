module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    assign out = a ~^ b; // Direct use of bitwise XNOR operator for clarity and optimal synthesis
endmodule