module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    if (a && !prev_a) begin
        p <= 1'b1;
    end else if (!a) begin
        p <= 1'b0;
    end
    prev_a <= a;
end

always @(negedge clock) begin
    if (p && !a) begin
        q <= 1'b1;
    end else if (!p || a) begin
        q <= 1'b0;
    end
end

endmodule