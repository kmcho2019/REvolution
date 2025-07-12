module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    if (a) begin
        prev_a <= 1'b1;
    end
    if (~a && ~prev_a) begin
        p <= 1'b0;
    end else if (a) begin
        p <= 1'b1;
    end
end

always @(posedge clock) begin
    if (p) begin
        q <= 1'b1;
    end else if (~a && ~p) begin
        q <= 1'b0;
    end
end

endmodule