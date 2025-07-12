module TopModule (
    input a,
    input b,
    output out
);
    // Optimal XNOR implementation using direct ~^ operator
    assign out = a ~^ b;
endmodule