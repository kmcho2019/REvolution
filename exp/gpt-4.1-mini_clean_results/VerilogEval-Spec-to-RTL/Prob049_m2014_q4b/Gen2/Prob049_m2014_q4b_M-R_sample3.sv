module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg reset_async;

always @(*) begin
    // Asynchronous reset logic
    reset_async = ar;
end

always @(posedge clk or posedge reset_async) begin
    if (reset_async)
        q <= 1'b0;
    else
        q <= d;
end

endmodule