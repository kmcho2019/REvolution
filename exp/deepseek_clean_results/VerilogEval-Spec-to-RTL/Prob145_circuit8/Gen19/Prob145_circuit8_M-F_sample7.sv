module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p is now a positive-edge triggered flip-flop
always @(posedge clock) begin
    p <= a;
end

// q remains a negative-edge triggered flip-flop sampling p
always @(negedge clock) begin
    q <= p;
end

endmodule