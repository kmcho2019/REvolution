module TopModule (
    input  logic a,
    input  logic b,
    input  logic sel,
    output logic out
);

assign out = sel ? b : a;

endmodule