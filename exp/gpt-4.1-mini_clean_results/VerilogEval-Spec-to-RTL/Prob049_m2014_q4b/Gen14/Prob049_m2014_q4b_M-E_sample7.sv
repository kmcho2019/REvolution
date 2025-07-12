module TopModule (
    input clk,
    input ar,      // Asynchronous active-high reset input
    input d,
    output reg q
);

reg async_reset_sync;

always @(*) begin
    // async_reset_sync is high immediately when ar is high, otherwise low
    async_reset_sync = ar;
end

always @(posedge clk) begin
    if (async_reset_sync)
        q <= 1'b0;
    else
        q <= d;
end

endmodule