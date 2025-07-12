module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg, prev_clk;

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

always @(*) begin
    if (clk == 1 && prev_clk == 0) begin // positive edge
        q = q_pos;
    end else if (clk == 0 && prev_clk == 1) begin // negative edge
        q = q_neg;
    end else begin
        q = q; // hold value
    end
end

always @(posedge clk) begin
    prev_clk <= clk;
end

endmodule