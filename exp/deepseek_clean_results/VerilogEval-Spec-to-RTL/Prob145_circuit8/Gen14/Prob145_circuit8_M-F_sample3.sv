module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg seen_p_high;

always @(posedge clock) begin
    if (!q) begin
        p <= a;
        if (a) begin
            seen_p_high <= 1;
        end
    end else begin
        p <= 0;
    end

    if (seen_p_high && !a) begin
        q <= 1;
    end
end

always @(negedge clock) begin
    if (a && q) begin
        q <= 0;
        seen_p_high <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    seen_p_high = 0;
end

endmodule