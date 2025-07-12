module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize registers to 0 as indicated by waveform stable points
initial begin
    p = 0;
    q = 0;
end

// p updated on rising edge of clock
always @(posedge clock) begin
    if (a == 1'b1)
        p <= 1'b1;
    else if ((a == 1'b0) && (q == 1'b1))
        p <= 1'b0;
    else
        p <= p;
end

// q updated on falling edge of clock, capturing p
always @(negedge clock) begin
    q <= p;
end

endmodule