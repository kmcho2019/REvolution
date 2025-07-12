module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize outputs to 0 to avoid unknown states
initial begin
    p = 0;
    q = 0;
end

// Update p at rising edge of clock, sampling 'a'
always @(posedge clock) begin
    p <= a;
end

// Update q at falling edge of clock, reset if clock=0 and a=1, else latch q with OR of q and p
always @(negedge clock) begin
    if (a)
        q <= 0;
    else
        q <= q | p;
end

endmodule