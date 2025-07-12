module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    assign out = a ~^ b; // Use Verilog built-in bitwise XNOR operator with continuous assignment
endmodule