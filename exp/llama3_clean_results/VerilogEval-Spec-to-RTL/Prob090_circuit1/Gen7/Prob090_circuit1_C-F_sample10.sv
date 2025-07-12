module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

assign q = a & b; // Directly implement the AND gate logic

endmodule