module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Asynchronous reset latch (level sensitive)
reg async_reset_latch;

always @(*) begin
    if (ar)
        async_reset_latch = 1'b1;
    else
        async_reset_latch = 1'b0;
end

// D flip-flop with synchronous load of reset state
always @(posedge clk) begin
    if (async_reset_latch)
        q <= 1'b0;
    else
        q <= d;
end

endmodule