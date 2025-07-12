// TopModule: A combinational circuit using assign statement to implement the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Define the output q using conditional operators
    assign q = (
        (!a && !b && !c && !d) ||
        (!a && !b && c && d) ||
        (!a && b && !c && d) ||
        (!a && b && c && !d) ||
        (a && !b && !c && d) ||
        (a && !b && c && !d) ||
        (a && b && !c && !d) ||
        (a && b && c && d)
    ) ? 1'b1 : 1'b0;

endmodule