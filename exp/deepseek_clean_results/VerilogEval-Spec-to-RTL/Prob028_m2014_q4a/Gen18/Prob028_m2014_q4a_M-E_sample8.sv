module TopModule (
    input d,
    input ena,
    output reg q
);

always @(ena or d) begin
    if (ena) begin
        q = d;  // Transparent when enabled
    end
    // Implicit else retains previous value (latch behavior)
end

endmodule