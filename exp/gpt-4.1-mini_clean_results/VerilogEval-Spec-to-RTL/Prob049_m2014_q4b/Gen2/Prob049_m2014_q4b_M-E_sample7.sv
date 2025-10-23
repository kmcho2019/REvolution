module TopModule (
    input  clk,
    input  ar,    // Asynchronous reset, active high
    input  d,
    output reg q
);

reg async_reset_latch;

// Asynchronous latch capturing the reset signal
always @(*) begin
    if (ar)
        async_reset_latch = 1'b1;
    else if (clk)
        async_reset_latch = 1'b0;
    else
        async_reset_latch = async_reset_latch;
end

// Synchronous D flip-flop with synchronous reset driven by async latch
always @(posedge clk) begin
    if (async_reset_latch)
        q <= 1'b0;
    else
        q <= d;
end

endmodule