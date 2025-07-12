module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

assign q = (a) ? b : 0;

endmodule