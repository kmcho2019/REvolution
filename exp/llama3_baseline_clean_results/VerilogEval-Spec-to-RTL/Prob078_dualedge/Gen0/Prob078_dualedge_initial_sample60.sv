module TopModule (
    input  clk,
    input  d,
    output q
);

reg internal_q;

always @(posedge clk) begin
    internal_q <= d;
end

always @(negedge clk) begin
    q <= internal_q;
end

always @(posedge clk) begin
    q <= internal_q;
end

endmodule