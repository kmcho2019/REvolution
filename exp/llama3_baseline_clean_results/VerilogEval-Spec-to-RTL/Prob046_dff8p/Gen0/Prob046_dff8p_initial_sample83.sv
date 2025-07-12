module TopModule (
    input           clk,
    input           reset,
    input   [7:0]    d,
    output  [7:0]    q
);

always_ff @(negedge clk) begin
    if (reset) begin
        q <= 8'd52;  // 0x34 in decimal is 52
    end else begin
        q <= d;
    end
end

endmodule