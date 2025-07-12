module TopModule(
    input  logic a,
    input  logic b,
    output logic out
);

// Implement a 2-input AND gate using a continuous assignment
assign out = a & b;

endmodule