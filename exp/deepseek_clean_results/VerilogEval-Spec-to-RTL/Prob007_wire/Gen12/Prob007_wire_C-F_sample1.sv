// Simple wire connection module
// Directly connects input 'in' to output 'out'
// Optimal implementation - minimal PPA impact
module TopModule (
    input  in,
    output out
);
    assign out = in;
endmodule