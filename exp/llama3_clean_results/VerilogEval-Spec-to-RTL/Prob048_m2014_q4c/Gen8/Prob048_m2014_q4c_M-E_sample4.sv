module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

reg latch_d;
reg latch_r;

always @(posedge clk) begin
    latch_d <= d;
    latch_r <= r;
end

always @(negedge clk) begin
    if (latch_r) begin
        q <= 1'b0;
    end else begin
        q <= latch_d;
    end
end

endmodule