module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Direct assignments for unique outputs
    assign w = a;
    assign z = c;

    // Intermediate wire directly connects b to both x and y
    wire b_shared;
    assign b_shared = b;

    assign x = b_shared;
    assign y = b_shared;

endmodule