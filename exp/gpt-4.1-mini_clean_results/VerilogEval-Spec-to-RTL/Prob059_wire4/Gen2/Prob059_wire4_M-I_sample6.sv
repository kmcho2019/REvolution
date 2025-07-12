module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

// Direct assignment for w and z
assign w = a;
assign z = c;

// Combine assignments for x and y driven by b to allow better optimization
assign {x, y} = {b, b};

endmodule