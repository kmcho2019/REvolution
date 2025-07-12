module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out
);

    // Directly implement the XOR operation among all inputs
    assign out = a ^ b ^ c ^ d;

endmodule