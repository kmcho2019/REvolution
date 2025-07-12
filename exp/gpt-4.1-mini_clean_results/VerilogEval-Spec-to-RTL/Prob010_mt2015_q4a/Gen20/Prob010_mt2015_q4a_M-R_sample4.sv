module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Simplified boolean function: z = x & ~y
    assign z = x & ~y;
endmodule