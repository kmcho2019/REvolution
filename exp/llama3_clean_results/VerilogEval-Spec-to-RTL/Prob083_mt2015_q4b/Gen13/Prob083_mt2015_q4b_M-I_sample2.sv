module TopModule(
    input x,
    input y,
    output logic z
);
    // Using an XOR gate to assign z
    assign z = ~(x ^ y);
endmodule