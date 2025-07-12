module TopModule (
    input  a,
    input  b,
    output out
);
    // Directly implement the NOR function to minimize hierarchy and overhead
    assign out = ~(a | b);
endmodule