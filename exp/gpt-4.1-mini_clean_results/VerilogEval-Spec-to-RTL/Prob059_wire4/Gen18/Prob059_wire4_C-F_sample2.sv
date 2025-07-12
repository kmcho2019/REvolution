module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Direct continuous assignments for all output signals
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;

endmodule