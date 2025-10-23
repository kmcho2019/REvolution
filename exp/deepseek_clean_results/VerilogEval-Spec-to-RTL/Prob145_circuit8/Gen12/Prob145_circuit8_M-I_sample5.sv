module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p is high when both 'a' and 'clock' are high
always @(posedge clock) begin
    p <= a;
end

// q captures p's value at falling edge of clock
always @(negedge clock) begin
    q <= p;
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule