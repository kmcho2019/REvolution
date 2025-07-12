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

initial begin
    p = 1'bx;
    q = 1'bx;
end

endmodule