// Superior Module TopModule: Parameterized for reusability and simplicity.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
    // Directly assign the input to the output for a combinational identity function
    assign out = in;

endmodule