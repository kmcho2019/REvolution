// TopModule: A combinational circuit using a lookup table to implement the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Define the lookup table using assign and case statement
    assign q = (
        (a == 1'b0 && b == 1'b0 && c == 1'b0 && d == 1'b0) ? 1'b1 :
        (a == 1'b0 && b == 1'b0 && c == 1'b0 && d == 1'b1) ? 1'b0 :
        (a == 1'b0 && b == 1'b0 && c == 1'b1 && d == 1'b0) ? 1'b0 :
        (a == 1'b0 && b == 1'b0 && c == 1'b1 && d == 1'b1) ? 1'b1 :
        (a == 1'b0 && b == 1'b1 && c == 1'b0 && d == 1'b0) ? 1'b0 :
        (a == 1'b0 && b == 1'b1 && c == 1'b0 && d == 1'b1) ? 1'b1 :
        (a == 1'b0 && b == 1'b1 && c == 1'b1 && d == 1'b0) ? 1'b1 :
        (a == 1'b0 && b == 1'b1 && c == 1'b1 && d == 1'b1) ? 1'b0 :
        (a == 1'b1 && b == 1'b0 && c == 1'b0 && d == 1'b0) ? 1'b0 :
        (a == 1'b1 && b == 1'b0 && c == 1'b0 && d == 1'b1) ? 1'b1 :
        (a == 1'b1 && b == 1'b0 && c == 1'b1 && d == 1'b0) ? 1'b1 :
        (a == 1'b1 && b == 1'b0 && c == 1'b1 && d == 1'b1) ? 1'b0 :
        (a == 1'b1 && b == 1'b1 && c == 1'b0 && d == 1'b0) ? 1'b1 :
        (a == 1'b1 && b == 1'b1 && c == 1'b0 && d == 1'b1) ? 1'b0 :
        (a == 1'b1 && b == 1'b1 && c == 1'b1 && d == 1'b0) ? 1'b0 :
        (a == 1'b1 && b == 1'b1 && c == 1'b1 && d == 1'b1) ? 1'b1 :
        1'bx
    );

endmodule