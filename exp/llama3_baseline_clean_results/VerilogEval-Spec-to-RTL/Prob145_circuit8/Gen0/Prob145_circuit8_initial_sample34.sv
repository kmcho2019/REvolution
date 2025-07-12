module TopModule(
    input clock,
    input a,
    output p,
    output reg q
);

reg prev_a;

initial begin
    q = 0;
    prev_a = 0;
end

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    if (prev_a) begin
        q <= ~q;
    end
    prev_a <= a;
end

endmodule