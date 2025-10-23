module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg prev_clk;
reg q_pos;
reg q_neg;

always @(posedge clk) begin
    q_pos <= d;
    prev_clk <= 1'b1;
end

always @(negedge clk) begin
    q_neg <= d;
    prev_clk <= 1'b0;
end

always @(*) begin
    if (clk !== prev_clk) begin
        if (clk == 1'b1) begin
            q <= q_pos;
        end else begin
            q <= q_neg;
        end
    end
end

endmodule