module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg latch_data;

always @(posedge clk) begin
    latch_data <= d;
end

always @(*) begin
    if (r) begin
        q = 1'b0;
    end else if (clk) begin
        q = latch_data;
    end else begin
        // Hold the previous value when clock is low
        // This is to ensure that q doesn't change unexpectedly
        // when the clock is not active.
    end
end

endmodule