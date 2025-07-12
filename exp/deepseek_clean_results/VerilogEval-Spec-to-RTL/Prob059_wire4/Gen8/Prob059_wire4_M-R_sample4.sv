module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

    // Grouped and aligned assignments for clarity
    assign w = a;
    assign x = b,
           y = b;
    assign z = c;

endmodule