module TopModule(
    input x,
    input y,
    output logic z
);
    // Using a K-map derived Boolean expression
    assign z = ~(x ^ y);
endmodule