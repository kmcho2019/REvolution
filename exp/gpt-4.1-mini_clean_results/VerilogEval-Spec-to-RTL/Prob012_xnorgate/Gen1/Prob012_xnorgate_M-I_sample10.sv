module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b; // Use Verilog XNOR operator for clarity and synthesis optimization
endmodule