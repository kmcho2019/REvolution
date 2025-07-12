module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    p <= a;
    if (a && prev_a) begin
        q <= ~q;
    end else if (a) begin
        q <= 0;
    end else if (p) begin
        q <= ~q;
    end
end

always @(negedge clock) begin
    prev_a <= a;
end

endmodule