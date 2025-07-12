module TopModule (
    output logic out
);

    // Local parameter defines constant zero for clarity and maintainability
    localparam logic ZERO = 1'b0;

    // Continuous assignment drives output to constant zero
    assign out = ZERO;

endmodule