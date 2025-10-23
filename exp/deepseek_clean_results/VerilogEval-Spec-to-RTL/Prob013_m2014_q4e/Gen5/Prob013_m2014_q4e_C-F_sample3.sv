module TopModule (
    input in1,
    input in2,
    output out
);
    // Optimal direct implementation using continuous assignment
    assign out = ~(in1 | in2);
    
    // Alternative: Library-optimized primitive NOR
    // nor (out, in1, in2);
endmodule