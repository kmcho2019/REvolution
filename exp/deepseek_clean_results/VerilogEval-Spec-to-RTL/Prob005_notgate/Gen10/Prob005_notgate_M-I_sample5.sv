// Optimal NOT gate implementation - minimal PPA
module TopModule (
    input in,
    output out
);
    assign out = ~in;  // Direct continuous assignment - optimal implementation
endmodule