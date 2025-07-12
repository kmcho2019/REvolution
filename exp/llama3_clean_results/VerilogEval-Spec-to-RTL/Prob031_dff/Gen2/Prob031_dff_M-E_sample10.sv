module TopModule(
    input clk,
    input d,
    output reg q
);

reg latch_d;

always @(*) begin
    if (~clk) begin
        latch_d <= d;
    end
end

always @(*) begin
    if (clk) begin
        q <= latch_d;
    end else begin
        q <= q; // To maintain the previous state when clk is low
    end
end

endmodule