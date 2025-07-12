module TopModule (
    input clk,
    input d,
    output q
);

reg internal_q1;
reg internal_q2;
reg prev_clk;

always @(posedge clk) begin
    internal_q1 <= d;
end

always @(negedge clk) begin
    internal_q2 <= d;
end

always @(posedge clk) begin
    prev_clk <= clk;
end

assign q = (prev_clk == 1'b0) ? internal_q1 : internal_q2;

endmodule