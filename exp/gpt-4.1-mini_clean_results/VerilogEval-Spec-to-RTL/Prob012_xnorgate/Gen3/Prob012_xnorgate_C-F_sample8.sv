module TopModule (
    input  a,
    input  b,
    output out
);
    // Single-gate XNOR implementation using the Verilog bitwise XNOR operator (~^)
    // This expression synthesizes efficiently to a minimal gate with optimal performance, area, and power.
    assign out = a ~^ b;
endmodule