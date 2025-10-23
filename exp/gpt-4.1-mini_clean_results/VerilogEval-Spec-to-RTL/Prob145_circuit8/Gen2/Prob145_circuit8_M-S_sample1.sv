module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize outputs to 0
initial begin
    p = 0;
    q = 0;
end

// Update p at rising edge of clock (p follows a)
always @(posedge clock) begin
    p <= a;
end

// Update q at falling edge of clock (q latches previous p)
always @(negedge clock) begin
    q <= p;
end

endmodule