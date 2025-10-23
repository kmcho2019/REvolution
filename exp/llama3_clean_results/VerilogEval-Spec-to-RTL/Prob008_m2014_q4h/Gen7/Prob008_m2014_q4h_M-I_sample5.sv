module TopModule(
    input  logic in,
    output logic out
);
    // Direct assignment as before, with consideration for synthesis optimization
    assign out = in;
endmodule