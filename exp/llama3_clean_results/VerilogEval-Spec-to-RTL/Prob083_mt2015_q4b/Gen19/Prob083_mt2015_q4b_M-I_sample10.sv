module TopModule(
    input x,
    input y,
    output logic z
);
    // Using a simple assignment for combinational logic
    assign z = (x === y); // Using === for exact comparison
endmodule