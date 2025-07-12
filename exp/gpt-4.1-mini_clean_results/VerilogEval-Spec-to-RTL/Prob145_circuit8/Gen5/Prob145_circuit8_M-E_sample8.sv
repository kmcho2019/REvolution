module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

initial begin
    p = 1'b0;
    q = 1'b0;
end

// At rising edge of clock, p captures a OR q to hold previous state or new input 'a'
always @(posedge clock) begin
    p <= a | q;
end

// At falling edge of clock, q captures current p, effectively latching the state
always @(negedge clock) begin
    q <= p;
end

endmodule