module TopModule(
    input  a,
    input  b,
    output q
);
    // Combinational logic: q is high only when both inputs are high (AND operation)
    assign q = a & b;
endmodule