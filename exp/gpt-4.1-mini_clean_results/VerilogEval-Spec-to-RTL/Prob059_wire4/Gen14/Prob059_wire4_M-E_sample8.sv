module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Direct assignments for unique input-output pairs
    assign w = a;
    assign z = c;

    // Internal wire for input b fanout to outputs x and y
    wire b_internal;
    assign b_internal = b;
    assign x = b_internal;
    assign y = b_internal;

endmodule