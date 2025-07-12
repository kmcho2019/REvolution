module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

    logic parity;
    assign parity = a ^ b ^ c ^ d;
    assign q = ~parity;

endmodule