module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a | b);  // Continuous assignment for NOR operation
endmodule