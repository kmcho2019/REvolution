// Refactored Module TopModule: Direct assignment for input-output
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
    // Directly assign the input value to the output
    assign out = in;

endmodule