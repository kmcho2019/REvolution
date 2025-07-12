module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    if (~prev_a && a) begin
        q <= ~q;
    end
    prev_a <= a;
end

always @(posedge clk) begin
    if (~a && ~q) begin
        q <= 1'b1;
    end
end

initial begin
    q = 1'b0;
    prev_a = 1'b0;
end

endmodule