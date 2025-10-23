module TopModule (
    input in,
    output out
);
    // Optimal wire implementation - minimal PPA impact
    assign out = in;
endmodule