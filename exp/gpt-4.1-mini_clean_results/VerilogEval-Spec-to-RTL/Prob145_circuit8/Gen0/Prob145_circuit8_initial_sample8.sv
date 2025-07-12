module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (q == 0)
        p <= a;
    else
        p <= a ? 1'b1 : 1'b0;
end

always @(negedge clock) begin
    q <= p;
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule