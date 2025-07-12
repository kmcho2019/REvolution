module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a ^ b);  // Optimal XNOR implementation
endmodule