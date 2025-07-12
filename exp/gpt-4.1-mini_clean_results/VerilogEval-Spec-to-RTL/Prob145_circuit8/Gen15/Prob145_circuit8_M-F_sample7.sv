module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 0;
    q = 0;
end

// Update p on rising edge: p = a & ~q
always @(posedge clock) begin
    p <= a & (~q);
end

// Update q on falling edge: q <= p
always @(negedge clock) begin
    q <= p;
end

endmodule