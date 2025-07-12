module TopModule(
    input  logic in,
    output logic out
);
    // Directly assign the input to the output to maintain simplicity and efficiency
    // This approach minimizes area and power consumption, and does not introduce any timing overhead
    assign out = in;
endmodule