module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Original optimal implementation
    (* use_low_power_cell = 1 *)  // Synthesis attribute for low-power optimization
    assign q = (a | b) & (c | d);

endmodule