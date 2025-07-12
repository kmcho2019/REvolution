module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg reset_sync_latch;

always @(*) begin
    if (ar)
        reset_sync_latch = 1'b1;
    else
        reset_sync_latch = 1'b0;
end

always @(posedge clk) begin
    if (reset_sync_latch)
        q <= 1'b0;
    else
        q <= d;
end

endmodule