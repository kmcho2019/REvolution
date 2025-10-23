module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

wire async_clear;

assign async_clear = ar;

always @(posedge clk) begin
    if (async_clear)
        q <= 1'b0;
    else
        q <= d;
end

endmodule