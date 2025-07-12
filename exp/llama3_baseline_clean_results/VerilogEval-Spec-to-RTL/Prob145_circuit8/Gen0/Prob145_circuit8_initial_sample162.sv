module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if(a) begin
        p <= 1;
        q <= ~q;
    end else begin
        p <= 0;
    end
end

always @(negedge clock) begin
    if(~a) begin
        q <= q;
    end else begin
        q <= q;
    end
end

always @(negedge clock or a) begin
    if(a && ~clock) begin
        q <= q;
    end else if (~a && ~clock) begin
        q <= q;
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule