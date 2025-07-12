module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Directly implement simplified function: z = x & ~y
    assign z = x & ~y;
endmodule