module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

initial begin
    p = 1'b0;
    q = 1'b0;
    p_prev = 1'b0;
end

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    if (p_prev && a) begin
        q <= 1'b1;
    end else if (!a) begin
        q <= 1'b0;
    end
    p_prev <= p;
end

endmodule