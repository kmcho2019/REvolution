module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Directly assign z using simplified Boolean expression
    assign z = x & ~y;
endmodule