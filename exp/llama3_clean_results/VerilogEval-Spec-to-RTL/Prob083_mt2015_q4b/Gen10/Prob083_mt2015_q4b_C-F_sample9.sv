module TopModule(
    input x,
    input y,
    output logic z
);
    // Direct assignment using the logic data type
    assign z = x == y;
endmodule