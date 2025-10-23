module TopModule (
    input d,
    input ena,
    output reg q  // Note: q must be reg type for always block assignment
);

always @(ena or d) begin
    if (ena) begin
        q = d;  // Transparent behavior when enabled
    end
    // Implicit else retains previous value (latch behavior)
end

endmodule