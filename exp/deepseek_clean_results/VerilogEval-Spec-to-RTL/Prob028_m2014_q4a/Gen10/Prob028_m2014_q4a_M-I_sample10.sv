module TopModule (
    input d,
    input ena,
    output reg q
);

// synthesis attribute latch of q is "yes"
// synthesis attribute power_optimization of q is "high"
// synthesis attribute retention of q is "yes"
// synthesis attribute clock_gating of ena is "yes"

always @* begin
    if (ena) q = d;  // Explicit latch behavior
end

/* Timing Constraints */
// synthesis attribute setup of d is "0.1"
// synthesis attribute hold of d is "0.05"
// synthesis attribute recovery of ena is "0.1"

endmodule