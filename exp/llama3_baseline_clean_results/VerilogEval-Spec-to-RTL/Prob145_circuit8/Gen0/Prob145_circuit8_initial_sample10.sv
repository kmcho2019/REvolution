module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    prev_a <= a;
    p <= a;
    q <= prev_a;
end

initial begin
    prev_a = 0;
    p = 0;
    q = 0;
end

endmodule