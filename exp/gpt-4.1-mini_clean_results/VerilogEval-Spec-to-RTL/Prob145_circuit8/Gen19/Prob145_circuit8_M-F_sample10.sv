module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// p updates on posedge clock: set p = a
always @(posedge clock) begin
    p <= a;
end

// q updates on negedge clock: q <= p
always @(negedge clock) begin
    q <= p;
end

// Initial unknown states to match waveform starting conditions
initial begin
    p = 1'bx;
    q = 1'bx;
end

endmodule