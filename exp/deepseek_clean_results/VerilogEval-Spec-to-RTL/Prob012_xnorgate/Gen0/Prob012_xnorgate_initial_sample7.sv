module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b;  // ~^ is the XNOR operator in Verilog
endmodule