module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @* begin
    p = (clock & a) | (~clock & q);
end

always @(negedge clock) begin
    q <= p;
end

endmodule