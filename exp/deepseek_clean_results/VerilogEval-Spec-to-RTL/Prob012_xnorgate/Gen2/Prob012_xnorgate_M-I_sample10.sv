module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a ^ b);  // Maintain optimal XNOR implementation
endmodule