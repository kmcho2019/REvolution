module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg q_async_reset;

always @(posedge clk) begin
    if (!ar)
        q_async_reset <= d;
end

always @(posedge ar or posedge clk) begin
    if (ar)
        q <= 1'b0;
    else
        q <= q_async_reset;
end

endmodule