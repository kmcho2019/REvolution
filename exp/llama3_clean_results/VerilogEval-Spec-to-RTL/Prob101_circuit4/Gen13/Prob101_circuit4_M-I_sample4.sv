module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Simplified logic expression using basic OR gate
assign q = b | c;

endmodule