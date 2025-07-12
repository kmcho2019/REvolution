module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock or posedge p) begin
    if (!clock)
        q <= p;
    else if (p)
        q <= 1'b1;
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule