module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    prev_a <= a;
end

always @(*) begin
    p = (clock & (a | prev_a));
end

always @(negedge clock) begin
    q <= p;
end

endmodule