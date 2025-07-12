module TopModule(
    input clk,
    input d,
    output reg q
);

reg last_edge_was_positive;
reg d_at_last_positive_edge;

always @(posedge clk) begin
    last_edge_was_positive <= 1'b1;
    d_at_last_positive_edge <= d;
end

always @(negedge clk) begin
    last_edge_was_positive <= 1'b0;
    q <= d;
end

always @(posedge clk) begin
    if (~last_edge_was_positive) begin
        q <= d_at_last_positive_edge;
    end else begin
        q <= d;
    end
end

endmodule