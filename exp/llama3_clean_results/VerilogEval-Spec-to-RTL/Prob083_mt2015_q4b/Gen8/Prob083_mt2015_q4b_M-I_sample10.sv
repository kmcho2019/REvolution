module TopModule(
    input x,
    input y,
    output logic z
);
    // Simplify the logic using a direct assignment
    assign z = x == y;
endmodule