module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Directly wire inputs to outputs using continuous assignments
    // This approach ensures minimal delay, power, and area usage.
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;

endmodule