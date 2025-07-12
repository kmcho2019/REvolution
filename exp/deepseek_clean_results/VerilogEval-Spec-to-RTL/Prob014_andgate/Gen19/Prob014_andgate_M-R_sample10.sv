module TopModule(
    input a,
    input b,
    output out
);
    assign out = a & b;  // Continuous assignment implementation of AND gate
endmodule