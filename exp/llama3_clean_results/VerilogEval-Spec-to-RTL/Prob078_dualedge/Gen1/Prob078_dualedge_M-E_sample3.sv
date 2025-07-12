module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg pos_q;
reg neg_q;
reg prev_clk;

always @(posedge clk) begin
    pos_q <= d;
end

always @(negedge clk) begin
    neg_q <= d;
end

always @(posedge clk or negedge clk) begin
    if (clk == 1'b1 && prev_clk == 1'b0) begin
        q <= pos_q;
    end else if (clk == 1'b0 && prev_clk == 1'b1) begin
        q <= neg_q;
    end
    prev_clk <= clk;
end

endmodule