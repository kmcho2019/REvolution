module TopModule (
    input in,
    output out
);
    // Optimal NOT gate implementation - minimal PPA (1 gate, 0 timing violations)
    assign out = ~in;
endmodule