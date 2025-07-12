module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

// Direct implementation of the required logic
assign out = a || b || c;

endmodule