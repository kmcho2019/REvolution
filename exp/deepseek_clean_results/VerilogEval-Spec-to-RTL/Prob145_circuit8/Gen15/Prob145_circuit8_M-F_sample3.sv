module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    if (!q) begin
        p <= a;
    end else begin
        p <= 0;
    end
    p_prev <= p;
end

always @(negedge clock or posedge a) begin
    if (a) begin
        q <= 0;
    end else if (p_prev) begin
        q <= 1;
    end
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule