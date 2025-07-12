module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
    // Using a buf to drive the output with the input value
    buf out(in);
endmodule