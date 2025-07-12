module TopModule(
    input clk,
    input d,
    output reg q
);

reg delayed_clk;
always @(posedge clk or negedge clk) begin
    delayed_clk <= #1 clk; // Delay the clock by 1 time unit
end

reg internal_q;
always @(posedge delayed_clk or negedge delayed_clk) begin
    if (delayed_clk == 1'b1) begin
        internal_q <= d;
    end else begin
        internal_q <= d;
    end
end

assign q = internal_q;

endmodule