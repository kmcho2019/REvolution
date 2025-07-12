module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Simplified implementation of z = (x ^ y) & x to z = x & ~y
    assign z = x & ~y;
endmodule