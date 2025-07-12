module TopModule (
    input a,
    input b,
    output out
);
    wire a_eq_b;
    assign a_eq_b = ~(a ^ b);  // Explicit XNOR as NOT-XOR
    assign out = a_eq_b;
endmodule