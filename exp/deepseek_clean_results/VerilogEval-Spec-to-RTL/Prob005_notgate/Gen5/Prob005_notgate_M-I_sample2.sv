module TopModule (
    input in,
    output out
);
    // Optimal NOT gate implementation
    // This will synthesize to a single inverter with minimal PPA impact
    assign out = ~in;
endmodule