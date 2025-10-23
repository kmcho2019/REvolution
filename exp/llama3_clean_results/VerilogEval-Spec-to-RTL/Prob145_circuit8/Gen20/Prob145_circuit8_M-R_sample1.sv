module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg seen_a;

always @(posedge clock) begin
    if (!a) begin
        seen_a <= seen_a;
    end else begin
        seen_a <= 1'b1;
    end
end

always @(posedge clock or negedge clock) begin
    if (!clock) begin
        if (a) begin
            p <= 0;
        end else if (seen_a) begin
            p <= 1;
        end else begin
            p <= 0;
        end
    end else begin
        p <= a && seen_a;
    end
    q <= seen_a;
end

endmodule