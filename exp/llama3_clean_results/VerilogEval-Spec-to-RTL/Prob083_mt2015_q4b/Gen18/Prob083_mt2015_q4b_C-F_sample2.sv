module TopModule(
    input x,
    input y,
    output logic z
);
    // Direct assignment using ~(x ^ y) for clarity and adherence to common Verilog practices
    assign z = ~(x ^ y);
endmodule