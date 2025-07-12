module TopModule(
    input  logic in,  // Declare input as logic type for clarity
    output logic out  // Declare output as logic type for clarity
);
    // The NOT gate is implemented using a simple and efficient assignment.
    // This approach is optimal for area and power efficiency, as it involves minimal logic.
    assign out = ~in;  // Directly invert the input signal
endmodule