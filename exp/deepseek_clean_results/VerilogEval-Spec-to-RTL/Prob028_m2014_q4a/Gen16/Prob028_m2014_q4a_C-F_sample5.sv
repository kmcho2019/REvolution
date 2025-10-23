module TopModule (
    input d,
    input ena,
    output reg q
);

// D latch implementation: q follows d when enabled, holds value otherwise
always @(ena or d) begin
    if (ena) q = d;
    // else q retains its value (implicit latch behavior)
end

endmodule