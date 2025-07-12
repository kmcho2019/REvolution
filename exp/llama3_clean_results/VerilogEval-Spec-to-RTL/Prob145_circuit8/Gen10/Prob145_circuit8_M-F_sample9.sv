module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    prev_a <= a;
end

always @(negedge clock) begin
    if (prev_a && ~a) begin
        p <= 1;
    end else if (~prev_a && a) begin
        p <= 0;
    end
    if (p) begin
        q <= 1;
    end else begin
        if (~a) begin
            q <= 0;
        end
    end
end

endmodule