module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        if (a) begin
            p <= 0;
            q <= 0;
        end else if (p && q) begin
            p <= 1;
            q <= 1;
        end else begin
            p <= 0;
            q <= 0;
        end
    end else begin // clock is high
        if (a) begin
            p <= 1;
            q <= 0;
        end else begin
            p <= 0;
            q <= 0;
        end
    end
end

always @(posedge a or negedge a) begin
    if (~clock && a) begin
        p <= 0;
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule