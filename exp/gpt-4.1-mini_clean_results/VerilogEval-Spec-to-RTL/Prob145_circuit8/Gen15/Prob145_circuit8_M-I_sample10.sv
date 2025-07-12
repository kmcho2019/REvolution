module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize outputs
initial begin
    p = 0;
    q = 0;
end

// p updates on positive edge of clock, depends on input a and current q
always @(posedge clock) begin
    p <= a & ~q;
end

// q updates on negative edge of clock, capturing p
always @(negedge clock) begin
    q <= p;
end

endmodule