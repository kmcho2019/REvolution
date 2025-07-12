module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a & ~q;
    if (a == 0)
        q <= 0;
    else
        q <= q | p;
end

endmodule