module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

wire async_reset = ar;

always @(posedge clk) begin
    if (async_reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule