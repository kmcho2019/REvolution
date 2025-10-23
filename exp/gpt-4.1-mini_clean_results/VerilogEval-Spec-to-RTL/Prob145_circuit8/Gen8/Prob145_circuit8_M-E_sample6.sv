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

// Update p on rising edge of clock
always @(posedge clock) begin
    p <= a | (p & ~q);
end

// Update q on falling edge of clock
always @(negedge clock) begin
    q <= p;
end

endmodule