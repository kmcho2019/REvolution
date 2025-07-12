module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg q_latch;

always @(posedge clock) begin
    p <= a;
    if (a) begin
        q_latch <= 1;
    end
    q <= q_latch;
end

initial begin
    p = 0;
    q = 0;
    q_latch = 0;
end

endmodule