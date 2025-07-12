module TopModule(
    input x,
    input y,
    output logic z
);
    // Refactored implementation using XOR and NOT operators
    assign z = ~(x ^ y);
endmodule