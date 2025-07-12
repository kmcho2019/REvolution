module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    // Continuous assignment for NOR operation
    // Using bitwise OR followed by inversion
    assign out = ~(a | b);
endmodule