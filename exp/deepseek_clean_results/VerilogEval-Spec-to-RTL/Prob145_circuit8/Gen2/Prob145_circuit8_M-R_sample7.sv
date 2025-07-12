module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

// p is high only when both clock and a are high
assign p = clock & a;

// q captures p's value at negative clock edges
always @(negedge clock) begin
    q <= p;
end

endmodule