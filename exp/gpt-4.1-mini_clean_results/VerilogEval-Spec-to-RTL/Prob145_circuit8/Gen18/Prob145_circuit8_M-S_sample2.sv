module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

reg p_next;

always @(posedge clock) begin
    q <= p;
    p <= a & q;
end

endmodule