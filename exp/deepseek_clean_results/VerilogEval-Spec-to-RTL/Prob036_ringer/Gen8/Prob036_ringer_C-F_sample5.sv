module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);
    // Design ensures mutual exclusivity: only one output activates when ring=1
    assign ringer = (ring & ~vibrate_mode);  // Ringer on in normal mode
    assign motor  = (ring &  vibrate_mode);  // Motor on in vibrate mode
endmodule