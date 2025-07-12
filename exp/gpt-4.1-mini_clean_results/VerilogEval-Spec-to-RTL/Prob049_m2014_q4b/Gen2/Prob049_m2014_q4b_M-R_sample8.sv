module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg async_reset;

always @(*) begin
    // Asynchronous reset signal directly reflects ar
    async_reset = ar;
end

always @(posedge clk) begin
    if (!async_reset)
        q <= d;
end

always @(*) begin
    if (async_reset)
        q <= 1'b0;
end

endmodule