module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Use a continuous assignment for simplicity and clarity in combinational logic
assign q = a & b;

endmodule