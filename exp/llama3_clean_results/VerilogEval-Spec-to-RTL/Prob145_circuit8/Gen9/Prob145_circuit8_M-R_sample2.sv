module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a_high;

always @(posedge clock) begin
    p <= a;
    prev_a_high <= a;
end

always @(negedge clock) begin
    q <= prev_a_high && a;
end

endmodule