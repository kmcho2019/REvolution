module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// Positive edge-triggered flip-flop for p
always @(posedge clock) begin
    p <= a;
end

// Negative edge-triggered flip-flop for q
always @(negedge clock) begin
    q <= p;
end

endmodule