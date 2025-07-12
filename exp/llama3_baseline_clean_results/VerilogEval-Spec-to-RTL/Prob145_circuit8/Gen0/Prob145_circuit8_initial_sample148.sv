module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
        if (p) begin
            q <= 1'b1;
        end
    end else begin
        p <= 1'b0;
        q <= 1'b0;
    end
end

always @(negedge clock) begin
    if (~a) begin
        q <= 1'b1;
    end
    if (~clock & ~a) begin
        q <= q;
    end
    if (~clock & a) begin
        q <= 1'b0;
    end
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule