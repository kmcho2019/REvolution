// Parameterized equality comparator with optimal PPA
module TopModule #(
    parameter WIDTH = 2
) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output z
);
    // Efficient equality comparison that synthesizes to:
    // Series of XNOR gates (bitwise equality) + AND reduction
    assign z = (A == B);

    // Timing specification
    specify
        (A => z) = 0;
        (B => z) = 0;
    endspecify

endmodule