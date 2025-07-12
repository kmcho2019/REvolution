module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Explicit synchronous reset with priority
    if (r) begin
        q <= 1'b0;
    end
    // Normal data path
    else begin
        q <= d;
    end
end

endmodule