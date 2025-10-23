module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

// p is purely combinational - high only when both clock and a are high
assign p = a & clock;

// q captures p's value on negative clock edges
always @(negedge clock) begin
    q <= p;
end

endmodule