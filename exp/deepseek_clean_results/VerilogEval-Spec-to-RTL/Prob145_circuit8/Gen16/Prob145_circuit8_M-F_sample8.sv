module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    // p logic: copy 'a' when q is 0
    if (~q) begin
        p <= a;
    end else begin
        p <= 0;
    end

    // q logic: set if p was 1 last cycle
    // reset if 'a' is high during any phase
    if (a) begin
        q <= 0;
    end else if (p_prev) begin
        q <= 1;
    end

    p_prev <= p;
end

initial begin
    p = 0;
    q = 0;
    p_prev = 0;
end

endmodule