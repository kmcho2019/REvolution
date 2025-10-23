module TopModule(
    input  logic in,  // Input signal
    output logic out   // Output signal, directly assigned from input
);
    // Directly assign input to output for optimal performance and area usage
    assign out = in;
endmodule