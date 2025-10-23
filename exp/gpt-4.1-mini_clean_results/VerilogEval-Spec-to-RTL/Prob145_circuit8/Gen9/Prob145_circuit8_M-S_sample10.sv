module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if ((p === 1'bx) || (q === 1'bx)) begin
        p <= 0;
        q <= 0;
    end else begin
        p <= (a & ~q) | (p & (a | q));
        q <= p | (q & ~a);
    end
end

endmodule