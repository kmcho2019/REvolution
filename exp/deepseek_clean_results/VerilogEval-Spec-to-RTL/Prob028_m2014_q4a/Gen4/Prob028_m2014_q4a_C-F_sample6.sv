module TopModule (
    input d,
    input ena,
    output q
);

// synthesis attribute latch of q is "yes"
// synthesis attribute power_optimization of q is "high"
assign q = ena ? d : q;  // Transparent latch: q follows d when enabled

endmodule