module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock or negedge clock) begin
    if (clock) begin
        p <= a;
    end else begin
        prev_a <= a;
        if (prev_a) begin
            q <= 1'b1;
        end
    end
end

always @(posedge clock) begin
    if (a) begin
        q <= 1'b1;
    end else if (~prev_a) begin
        q <= 1'b0;
    end
end

endmodule