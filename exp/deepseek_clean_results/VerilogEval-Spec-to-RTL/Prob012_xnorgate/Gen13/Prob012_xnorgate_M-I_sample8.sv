module TopModule (
    input a,
    input b,
    output out
);
    // Direct XNOR implementation using Verilog operator
    assign out = ~(a ^ b);
endmodule