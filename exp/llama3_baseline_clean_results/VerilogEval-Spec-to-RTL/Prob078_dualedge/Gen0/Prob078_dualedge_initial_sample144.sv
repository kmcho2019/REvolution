module TopModule(
    input clk,
    input d,
    output q
);

reg internal_q;
reg internal_q_rising;
reg internal_q_falling;

always @(posedge clk) begin
    internal_q_rising <= d;
end

always @(negedge clk) begin
    internal_q_falling <= d;
end

always @(posedge clk or negedge clk) begin
    if (clk) begin
        internal_q <= internal_q_rising;
    end else begin
        internal_q <= internal_q_falling;
    end
end

assign q = internal_q;

endmodule