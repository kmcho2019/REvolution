module TopModule(
    input  a,
    input  b,
    output q
);
    // Combinational logic: output q is high only when both inputs a and b are high (AND gate)
    assign q = a & b;
endmodule