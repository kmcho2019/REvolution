module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_sampled;

always @(negedge clock) begin
    a_sampled <= a;
end

always @(posedge clock) begin
    if (q) begin
        p <= 0;
        if (a_sampled) begin
            q <= 0;
        end
    end else begin
        p <= a;
        if (p) begin
            q <= 1;
        end
    end
end

initial begin
    p = 0;
    q = 0;
    a_sampled = 0;
end

endmodule