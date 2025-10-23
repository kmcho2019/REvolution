module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a | (p & q);
end

always @(negedge clock) begin
    q <= p;
end

endmodule