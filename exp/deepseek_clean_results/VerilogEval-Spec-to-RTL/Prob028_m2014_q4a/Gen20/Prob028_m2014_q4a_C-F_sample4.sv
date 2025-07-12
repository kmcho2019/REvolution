module TopModule (
    input d,
    input ena,
    output reg q
);

// synthesis attribute latch of q is "yes"
// synthesis attribute power_optimization of q is "high"

// Transparent latch: q follows d when enabled (ena=1), holds value otherwise
assign q = ena ? d : q;

endmodule