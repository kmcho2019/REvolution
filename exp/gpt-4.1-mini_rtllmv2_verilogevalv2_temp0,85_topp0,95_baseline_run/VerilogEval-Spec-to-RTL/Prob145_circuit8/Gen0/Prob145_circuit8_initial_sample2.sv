module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 0;
    q = 0;
end

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    q <= p;
    p <= p & ~a;
end

endmodule