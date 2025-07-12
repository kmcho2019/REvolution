module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    p <= a;
    p_prev <= p;
    
    if (p_prev) begin
        q <= 1;
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule