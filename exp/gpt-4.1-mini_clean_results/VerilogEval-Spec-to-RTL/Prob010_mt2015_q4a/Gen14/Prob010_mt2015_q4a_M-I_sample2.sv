module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Simplified logic: z = x & ~y
    assign z = x & ~y;
endmodule