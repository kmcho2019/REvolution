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
    if (q == 0)
        p <= a;
    else
        p <= 0;
end

always @(negedge clock) begin
    q <= p;
end

endmodule