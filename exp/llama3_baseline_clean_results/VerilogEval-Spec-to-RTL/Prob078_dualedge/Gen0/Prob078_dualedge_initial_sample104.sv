module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg internal_q;

always @(posedge clk) begin
    q <= d;
end

always @(negedge clk) begin
    internal_q <= d;
end

always @(*) begin
    q <= (clk == 1'b1) ? q : internal_q;
end

endmodule