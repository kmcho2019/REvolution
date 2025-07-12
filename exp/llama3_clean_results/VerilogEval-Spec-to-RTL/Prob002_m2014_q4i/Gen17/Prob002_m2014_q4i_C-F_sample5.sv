module TopModule(
    output logic [0:0] out // Explicit bit width specification for clarity
);
    parameter OUT_VALUE = 1'b0; // Parameter for flexibility
    // Direct assignment to the parameter value for simplicity and low power consumption
    assign out = OUT_VALUE;

endmodule