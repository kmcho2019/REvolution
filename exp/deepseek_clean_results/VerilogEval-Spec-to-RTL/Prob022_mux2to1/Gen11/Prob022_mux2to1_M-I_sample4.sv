module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Transmission gate implementation using tri-state buffers
    // More power-efficient as only one path is active at a time
    assign out = ~sel ? a : 1'bz;
    assign out = sel ? b : 1'bz;
endmodule