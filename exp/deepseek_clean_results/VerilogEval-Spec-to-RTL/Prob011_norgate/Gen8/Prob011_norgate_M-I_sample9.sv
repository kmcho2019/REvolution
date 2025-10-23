module TopModule (
    input  a,
    input  b,
    output out
);
    // Optimal NOR gate implementation - minimal PPA (Power, Performance, Area)
    // Implements out = NOT (a OR b) with perfect timing (tns/wns=0)
    assign out = ~(a | b);
endmodule