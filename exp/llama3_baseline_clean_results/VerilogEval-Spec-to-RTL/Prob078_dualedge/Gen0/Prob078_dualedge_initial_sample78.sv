module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_pos;  // output of positive edge flip-flop
reg q_neg;  // output of negative edge flip-flop
reg prev_clk;  // previous clock value

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
end

always @(posedge q_pos or posedge q_neg or negedge prev_clk or posedge prev_clk) begin
    if (prev_clk == 1'b0) begin
        q <= q_pos;
    end else begin
        q <= q_neg;
    end
end

endmodule