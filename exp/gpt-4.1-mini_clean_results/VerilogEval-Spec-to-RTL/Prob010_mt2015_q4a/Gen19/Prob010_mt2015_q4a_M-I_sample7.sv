module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

    // Implement directly using simplified Boolean expression
    assign z = x & ~y;

endmodule