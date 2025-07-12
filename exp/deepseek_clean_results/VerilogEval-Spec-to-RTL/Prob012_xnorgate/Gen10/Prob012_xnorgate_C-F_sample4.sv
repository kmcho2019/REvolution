module TopModule (
    input a,
    input b,
    output out
);
    // XNOR implementation: out = 1 when (a == b), 0 otherwise
    // Directly implemented using XNOR operator for optimal PPA
    assign out = a ^~ b;
endmodule