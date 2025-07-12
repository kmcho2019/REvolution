module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a = 0;

always @(posedge clock) begin
    p <= a;
    if (a) begin
        prev_a <= 1;
    end
end

always @(posedge clock or negedge clock) begin
    if (!clock) begin
        q <= prev_a;
    end else begin
        if (prev_a) begin
            q <= 1;
        end else begin
            q <= 0;
        end
    end
end

endmodule