module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Implementing OR using NAND gates directly
assign q = ~(~b & ~c);

endmodule