module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_q;

always @(posedge clock) begin
    if (a) begin
        p <= 1;
        prev_q <= q;
    end else begin
        p <= 0;
    end
end

always @(negedge clock) begin
    if (prev_q == 0) begin
        if (a) begin
            q <= 1;
        end
    end else if (prev_q == 1) begin
        if (a) begin
            q <= 1;
        end else begin
            q <= 0;
        end
    end
end

initial begin
    p = 0;
    q = 0;
    prev_q = 0;
end

endmodule