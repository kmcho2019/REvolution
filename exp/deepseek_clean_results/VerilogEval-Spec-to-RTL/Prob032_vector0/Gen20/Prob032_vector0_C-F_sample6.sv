module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);
    // Optimal implementation combining best aspects of both examples:
    // - Direct wiring for best PPA
    // - Explicit bit assignments for clarity
    // - Documented optimality
    
    assign outv = vec;      // Full vector output
    assign o2 = vec[2];     // MSB
    assign o1 = vec[1];     // Middle bit
    assign o0 = vec[0];     // LSB

endmodule