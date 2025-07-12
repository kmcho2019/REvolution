module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
    // Direct assignment for minimal area and power consumption
    assign out = in;
endmodule