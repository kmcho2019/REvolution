module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
    // Simplified implementation using an assign statement
    assign out = sel ? b : a;
endmodule