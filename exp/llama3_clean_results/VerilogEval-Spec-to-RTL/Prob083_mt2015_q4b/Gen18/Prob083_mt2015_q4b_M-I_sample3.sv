module TopModule(
    input x,
    input y,
    output logic z
);
    // Simplified implementation using a NOR gate
    // The output 'z' is 1 when both 'x' and 'y' are 0, or when both 'x' and 'y' are 1
    assign z = ~(x | y); // NOR operation
    // This is equivalent to the original implementation using XOR and NOT gates
    // assign z = ~(x ^ y);
endmodule