module TopModule(
    input  logic in,
    output logic out
);
    // Direct assignment is the most efficient way to perform this operation.
    // No additional logic or operations are needed, which minimizes area and power consumption.
    assign out = in;
endmodule