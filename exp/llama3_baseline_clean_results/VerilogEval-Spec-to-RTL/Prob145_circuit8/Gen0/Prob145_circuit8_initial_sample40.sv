module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (~a) begin
        p <= 0;
        q <= 0;
    end else if (a) begin
        p <= 1;
        q <= 1;
    end
end

always @(negedge clock) begin
    if (~a) begin
        p <= 0;
        q <= 0;
    end else if (a) begin
        p <= 0;
        q <= 0;
    end else begin
        p <= p;
        q <= q;
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule