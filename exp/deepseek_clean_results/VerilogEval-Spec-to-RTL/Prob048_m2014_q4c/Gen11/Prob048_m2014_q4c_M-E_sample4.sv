module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q = 1'b0
);

// Edge-triggered latch implementation with synchronous reset
always @(*) begin
    if (clk) begin  // Transparent when clk is high
        if (r) q = 1'b0;  // Synchronous reset has priority
        else   q = d;     // Normal data path
    end
    // Implicit "else" retains value (latch behavior)
end

endmodule