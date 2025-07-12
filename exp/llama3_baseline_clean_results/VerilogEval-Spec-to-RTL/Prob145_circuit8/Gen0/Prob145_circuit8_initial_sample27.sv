module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p <= 1;
    end else begin
        p <= 0;
    end
end

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        if (a) begin
            q <= 0;
        end
    end else if (a) begin
        q <= p;
    end else if (~a) begin
        q <= q;
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule