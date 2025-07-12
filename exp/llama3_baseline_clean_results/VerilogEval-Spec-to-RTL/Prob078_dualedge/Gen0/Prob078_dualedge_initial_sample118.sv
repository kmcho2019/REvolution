module TopModule(
    input clk,
    input d,
    output q
);

reg q_rising;
reg q_falling;
reg prev_clk;

always @(posedge clk) begin
    q_rising <= d;
end

always @(negedge clk) begin
    q_falling <= d;
end

always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
    if (prev_clk == 1'b0 && clk == 1'b1) begin // rising edge
        q <= q_rising;
    end else if (prev_clk == 1'b1 && clk == 1'b0) begin // falling edge
        q <= q_falling;
    end
end

endmodule