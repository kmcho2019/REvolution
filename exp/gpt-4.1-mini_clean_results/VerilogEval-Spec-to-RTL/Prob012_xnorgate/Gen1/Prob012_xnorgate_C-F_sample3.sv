module TopModule(
    input a,
    input b,
    output out
);
    assign out = a ~^ b; // Explicit XNOR operator for clarity and synthesis
endmodule