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

// p updates on rising edge: p = a OR (p AND q)
always @(posedge clock) begin
    p <= a | (p & q);
end

// q updates on falling edge: q <= p
always @(negedge clock) begin
    q <= p;
end

endmodule