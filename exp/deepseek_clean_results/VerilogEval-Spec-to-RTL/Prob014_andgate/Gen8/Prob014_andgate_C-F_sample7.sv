module TopModule(
    input a,
    input b,
    output out
);
    // Optimal 2-input AND gate implementation
    // Uses direct continuous assignment for minimal PPA
    // Equivalent to single standard cell implementation
    assign out = a & b;
endmodule