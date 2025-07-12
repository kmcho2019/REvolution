module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

assign out = a || b || c;

endmodule