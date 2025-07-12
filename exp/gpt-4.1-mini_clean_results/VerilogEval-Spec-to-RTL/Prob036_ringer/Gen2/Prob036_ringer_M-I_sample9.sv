module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    // Using vibrate_mode as select signal for mux: output 1 on ringer or motor when ring=1
    // motor = ring & vibrate_mode
    // ringer = ring & ~vibrate_mode
    // Implemented as mux for clarity and reduced gate count

    assign ringer = ring & ~vibrate_mode;
    assign motor  = ring & vibrate_mode;

endmodule