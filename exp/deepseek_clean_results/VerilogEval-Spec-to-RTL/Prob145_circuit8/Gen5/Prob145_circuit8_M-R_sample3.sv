module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

reg prev_a;
reg p_reg;

always @(posedge clock) begin
    prev_a <= a;
    p_reg <= a | prev_a;
end

assign p = p_reg & clock;

always @(negedge clock) begin
    q <= p;
end

endmodule