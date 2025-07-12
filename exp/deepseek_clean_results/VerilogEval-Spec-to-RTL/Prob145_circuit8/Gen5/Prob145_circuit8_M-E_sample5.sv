module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p captures 'a' at positive clock edges
always @(posedge clock) begin
    p <= a;
end

// q captures p at negative clock edges
always @(negedge clock) begin
    q <= p;
end

endmodule