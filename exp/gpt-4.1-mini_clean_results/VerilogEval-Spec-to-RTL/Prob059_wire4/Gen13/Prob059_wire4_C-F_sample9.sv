module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Directly assign inputs to outputs; duplicate b drives both x and y directly
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;

endmodule