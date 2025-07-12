module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg async_reset_sync;

always @(*) begin
    // Combinationally reflect asynchronous reset input
    async_reset_sync = ar;
end

always @(posedge clk or posedge async_reset_sync) begin
    if (async_reset_sync)
        q <= 1'b0;
    else
        q <= d;
end

endmodule