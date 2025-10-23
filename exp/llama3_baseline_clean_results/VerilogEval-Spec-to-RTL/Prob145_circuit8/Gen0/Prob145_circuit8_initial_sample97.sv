module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    q <= p;
end

always @(negedge clock) begin
    // p and q will retain their previous values when clock is low
end

initial begin
    p = 0;
    q = 0;
end

endmodule