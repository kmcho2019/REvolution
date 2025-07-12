module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (p & a)
        q <= 1'b1;
    else
        q <= q;
end

always @(negedge clock) begin
    q <= 1'b0;
end

endmodule