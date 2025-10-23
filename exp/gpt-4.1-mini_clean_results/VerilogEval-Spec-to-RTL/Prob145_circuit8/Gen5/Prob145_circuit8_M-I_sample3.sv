module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 1'b0;
    q = 1'b0;
end

always @(posedge clock) begin
    // Set-dominant latch behavior: once p=1, it stays 1 unless reset (which does not occur)
    p <= p | a;
end

always @(negedge clock) begin
    // q latches p with set dominance, holding previous q if no set condition
    q <= q | p;
end

endmodule