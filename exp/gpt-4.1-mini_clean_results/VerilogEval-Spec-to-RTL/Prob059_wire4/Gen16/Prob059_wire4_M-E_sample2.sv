module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Concatenate inputs in the order of the outputs and assign in one statement
    assign {w, x, y, z} = {a, b, b, c};

endmodule