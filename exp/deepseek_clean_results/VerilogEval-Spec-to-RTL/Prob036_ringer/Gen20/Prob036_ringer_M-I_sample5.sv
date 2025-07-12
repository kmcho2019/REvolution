module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Optimized version with power and area considerations
    wire vibrate_mode_n = ~vibrate_mode;
    
    assign ringer = ring & vibrate_mode_n;  // Only active when needed
    assign motor  = ring & vibrate_mode;    // Only active when needed

endmodule