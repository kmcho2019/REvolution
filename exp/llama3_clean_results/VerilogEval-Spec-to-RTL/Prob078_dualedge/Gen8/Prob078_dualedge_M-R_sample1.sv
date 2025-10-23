module TopModule(
    input clk,
    input d,
    output q
);

reg q_pos;
reg q_neg;

initial begin
    q_pos = 0;
    q_neg = 0;
end

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

reg prev_clk;
initial begin
    prev_clk = 0;
end

always @(posedge clk or negedge clk) begin
    if (prev_clk!= clk) begin
        prev_clk <= clk;
        if (clk == 1) begin
            q <= q_pos;
        end else begin
            q <= q_neg;
        end
    end
end

endmodule