module TopModule (
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
    p <= a & q;
end

always @(negedge clock) begin
    q <= p;
end

endmodule