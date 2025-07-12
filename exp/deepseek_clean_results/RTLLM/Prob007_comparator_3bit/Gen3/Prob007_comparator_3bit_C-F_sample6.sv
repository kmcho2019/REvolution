module comparator_3bit #(
    parameter WIDTH = 3
) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct continuous assignments for optimal PPA
    // The conditions are mutually exclusive by definition
    assign A_greater = (A > B);
    assign A_equal   = (A == B);
    assign A_less    = (A < B);

endmodule