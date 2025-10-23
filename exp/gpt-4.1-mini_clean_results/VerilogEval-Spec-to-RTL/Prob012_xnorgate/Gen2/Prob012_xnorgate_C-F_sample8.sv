module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b; // Single gate XNOR using Verilog operator for optimal synthesis and clarity
endmodule