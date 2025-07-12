module TopModule(
    input a,
    input b,
    output out
);
    assign out = (a & b) | (~a & ~b);  // Explicit XNOR logic
endmodule