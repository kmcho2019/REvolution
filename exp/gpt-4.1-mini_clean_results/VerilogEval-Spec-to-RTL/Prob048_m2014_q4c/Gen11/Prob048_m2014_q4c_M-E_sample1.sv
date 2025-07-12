module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

reg sync_reset;

always @(posedge clk) begin
    sync_reset <= r;  // synchronous reset generation
end

always @(posedge clk) begin
    if (sync_reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule