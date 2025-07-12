module TopModule (
    input d,
    input ena,
    output reg q
);

// synthesis attribute latch of q is "yes"
// synthesis attribute power_optimization of q is "high"
// synthesis attribute area_optimization of q is "high"
// synthesis attribute clock_gating of ena is "auto"

always @(*) begin
    if (ena) q = d;  // Transparent latch: q follows d when enabled
end

endmodule