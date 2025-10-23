module TopModule(
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic q
);

// Directly implement the logic for output q without intermediate wires
assign q = (a || b) && (c || d);

endmodule