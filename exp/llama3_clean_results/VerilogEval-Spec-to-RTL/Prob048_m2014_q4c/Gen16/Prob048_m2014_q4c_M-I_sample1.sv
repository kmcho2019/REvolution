module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Reset condition
    end else if (d !== q) begin // Update q only if d is different
        q <= d;
    end
end

endmodule