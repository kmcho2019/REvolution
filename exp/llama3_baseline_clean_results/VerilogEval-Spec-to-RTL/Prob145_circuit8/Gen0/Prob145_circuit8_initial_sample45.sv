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
    p <= 0;
    q <= q;
end

endmodule