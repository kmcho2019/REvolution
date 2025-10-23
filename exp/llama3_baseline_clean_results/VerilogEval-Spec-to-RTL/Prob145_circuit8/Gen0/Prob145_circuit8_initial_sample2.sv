module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_high_after_clock_high;

always @(posedge clock) begin
    p <= a;
    a_high_after_clock_high <= a_high_after_clock_high || a;
    q <= a_high_after_clock_high;
end

always @(negedge clock) begin
    a_high_after_clock_high <= 0;
    p <= 0;
end

endmodule