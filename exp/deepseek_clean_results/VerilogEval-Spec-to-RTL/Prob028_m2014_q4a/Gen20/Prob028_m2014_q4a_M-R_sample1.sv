module TopModule (
    input d,
    input ena,
    output reg q
);

// synthesis attribute latch of q is "yes"
// synthesis attribute power_optimization of q is "high"

always @(d or ena) begin
    if (ena) begin
        q <= d;  // Transparent when enabled
    end
    // Implicit else holds previous value (latch behavior)
end

endmodule