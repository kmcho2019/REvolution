module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Direct and efficient implementation of the AND gate
assign q = a & b;

// Alternatively, for clarity and modularity, the following could be used:
// always_comb begin
//     q = a & b;
// end

endmodule