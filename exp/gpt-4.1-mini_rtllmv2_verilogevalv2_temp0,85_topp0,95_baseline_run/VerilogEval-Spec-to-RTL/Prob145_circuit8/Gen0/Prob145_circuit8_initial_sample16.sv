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

// p updates on rising edge of clock
always @(posedge clock) begin
    p <= a;
end

// q updates on falling edge of clock, taking the value of p
always @(negedge clock) begin
    q <= p;
end

endmodule