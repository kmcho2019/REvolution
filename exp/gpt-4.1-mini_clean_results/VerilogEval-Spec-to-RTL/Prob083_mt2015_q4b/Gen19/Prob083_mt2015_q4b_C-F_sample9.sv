module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Assign z to 1 if x equals y, otherwise 0.
// Using equality comparison for clarity and readability.
assign z = (x == y);

endmodule