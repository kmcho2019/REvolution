module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Concatenate outputs and assign from concatenated inputs,
    // replicating b for both x and y outputs.
    assign {w, x, y, z} = {a, b, b, c};

endmodule