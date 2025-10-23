module TopModule(
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic q
);

// Direct implementation of the required logic
assign q = (a || b) && (c || d);

endmodule