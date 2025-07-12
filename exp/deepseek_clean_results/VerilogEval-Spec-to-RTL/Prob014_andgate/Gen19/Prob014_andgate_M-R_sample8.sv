module TopModule(
    input a,
    input b,
    output out
);
    assign out = a & b;  // Behavioral implementation of AND gate
endmodule