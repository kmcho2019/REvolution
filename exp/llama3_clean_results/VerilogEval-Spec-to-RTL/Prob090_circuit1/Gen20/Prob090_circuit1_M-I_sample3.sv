module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);
    // Continuous assignment for combinational logic
    assign q = a & b;
endmodule