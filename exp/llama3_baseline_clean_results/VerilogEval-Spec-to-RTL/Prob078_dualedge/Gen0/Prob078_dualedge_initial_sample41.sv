module TopModule(
    input clk,
    input d,
    output reg q
);

reg q1, q2;
reg prev_clk;

always @(posedge clk) begin
    q1 <= d;
    prev_clk <= 1'b1;
end

always @(negedge clk) begin
    q2 <= d;
    prev_clk <= 1'b0;
end

always @(*) begin
    if (prev_clk == 1'b1) begin
        q <= q1;
    end else begin
        q <= q2;
    end
end

endmodule