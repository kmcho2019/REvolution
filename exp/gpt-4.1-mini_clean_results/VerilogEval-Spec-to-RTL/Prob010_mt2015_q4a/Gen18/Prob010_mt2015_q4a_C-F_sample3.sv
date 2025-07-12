module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Direct implementation using the simplified boolean expression:
    // z = (x ^ y) & x = x & ~y
    assign z = x & (~y);
endmodule