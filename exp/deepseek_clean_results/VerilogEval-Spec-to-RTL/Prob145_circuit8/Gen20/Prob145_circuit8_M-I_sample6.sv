module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_stable;

// p is a transparent latch (active when clock is high)
always @(*) begin
    if (clock) p = a;
end

// Track when p has been stable for a full cycle
always @(negedge clock) begin
    p_stable <= p;
end

// q updates on negative edge only if p has been stable
always @(negedge clock) begin
    if (p_stable == p) q <= p;
end

endmodule