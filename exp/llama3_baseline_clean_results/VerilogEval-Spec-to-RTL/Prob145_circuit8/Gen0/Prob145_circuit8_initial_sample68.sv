module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
end

reg prev_a;
always @(posedge clock) begin
    prev_a <= a;
end

always @(negedge clock or posedge clock) begin
    if (~clock) begin
        if (prev_a) begin
            q <= 1;
        end else begin
            q <= 0;
        end
    end else begin
        if (a) begin
            q <= 0;
        end else begin
            q <= q;
        end
    end
end

endmodule