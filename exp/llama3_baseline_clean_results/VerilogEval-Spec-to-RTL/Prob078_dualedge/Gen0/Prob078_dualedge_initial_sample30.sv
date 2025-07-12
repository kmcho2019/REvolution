module TopModule(
    input clk,
    input d,
    output reg q
);

reg last_edge_was_rising;
reg q_rising;

always @(posedge clk) begin
    q_rising <= d;
    last_edge_was_rising <= 1'b1;
end

always @(negedge clk) begin
    q <= d;
    last_edge_was_rising <= 1'b0;
end

always @(posedge clk or negedge clk) begin
    if (last_edge_was_rising == 1'b1) begin
        q <= q_rising;
    end
end

endmodule