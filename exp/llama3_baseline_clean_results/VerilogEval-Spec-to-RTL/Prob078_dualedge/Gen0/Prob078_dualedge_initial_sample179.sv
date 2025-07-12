module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;
reg q_pos;
reg q_neg;
reg old_clk;

always @(posedge clk) begin
    q_pos <= d;
    old_clk <= 1'b1;
end

always @(negedge clk) begin
    q_neg <= d;
    old_clk <= 1'b0;
end

always @(posedge q_pos or negedge q_pos or posedge q_neg or negedge q_neg) begin
    if (q_pos == 1'b1 || q_neg == 1'b1) begin
        q_reg <= 1'b1;
    end else if (q_pos == 1'b0 && q_neg == 1'b0) begin
        q_reg <= 1'b0;
    end
end

assign q = q_reg;

endmodule