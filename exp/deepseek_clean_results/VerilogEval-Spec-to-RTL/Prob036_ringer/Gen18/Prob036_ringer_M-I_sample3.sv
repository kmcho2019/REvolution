module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Implement using NAND gates (inverters are NANDs with both inputs tied)
    wire not_ring, not_vibrate;
    
    // Inverters implemented as NAND gates
    nand(not_ring, ring, ring);
    nand(not_vibrate, vibrate_mode, vibrate_mode);
    
    // Ringer = ring & ~vibrate_mode = ~(~ring | vibrate_mode)
    nand(ringer, not_ring, vibrate_mode);
    
    // Motor = ring & vibrate_mode = ~(~ring | ~vibrate_mode)
    nand(motor, not_ring, not_vibrate);
endmodule