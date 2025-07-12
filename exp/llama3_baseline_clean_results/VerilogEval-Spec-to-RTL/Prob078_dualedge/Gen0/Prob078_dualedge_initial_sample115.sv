module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg q_rising, q_falling;
reg clk_phase;

always @(posedge clk) begin
    clk_phase <= ~clk_phase;
    q_rising <= d;
end

always @(negedge clk) begin
    q_falling <= d;
end

always @(posedge clk_phase or negedge clk_phase) begin
    if (clk_phase) begin
        q <= q_rising;
    end else begin
        q <= q_falling;
    end
end

endmodule