module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a ^ b);  // XNOR using continuous assignment
endmodule