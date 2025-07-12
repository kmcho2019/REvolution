module TopModule(
    input a,
    input b,
    output q
);
    // Combinational logic: output q is high only if both a and b are high
    assign q = a & b;
endmodule